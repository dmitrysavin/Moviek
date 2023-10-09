
import Foundation
import SwiftUI

protocol MoviesSearchVMSceneBuilder {
    associatedtype MovieDetailsVMType: MovieDetailsVM
    func makeMovieDetailsScreen(movie: Movie) -> MovieDetailsScreen<MovieDetailsVMType>
}

protocol MoviesVMInput {
    associatedtype MovieDetailsVMType: MovieDetailsVM
    
    func didSearch(text searchText: String)
    func didCancelSearch()
    func didLoadNextPage()
    func didSelectItem(at index: Int) -> MovieDetailsScreen<MovieDetailsVMType>
}

protocol MoviesVMOutput {
    associatedtype MoviesQueriesVMType: MoviesQueriesVM
    
    var items: [MovieCellVM] { get }
    var searchText: String { get set }
    var loadingState: ViewModelLoadingState { get }
    var moviesQueriesVM: MoviesQueriesVMType { get }
    
    var showAlert: Bool { get set }
    var errorMessage: String { get }
}

protocol MoviesSearchVM: MoviesVMInput & MoviesVMOutput & ObservableObject {
}

final class DefaultMoviesVM: MoviesSearchVM {

    private let sceneBuilder: MoviesSceneBuilder
    
    @Published var items: [MovieCellVM] = []
    @Published var searchText: String = ""
    @Published var loadingState: ViewModelLoadingState = .none

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    var moviesQueriesVM: DefaultMoviesQueriesVM
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    private var pages: [MoviesPage] = []
    private let mainQueue: DispatchQueueType
    private let loadNextPageCoordinator: LoadNextPageCoordinator
    private let posterImagesRepository: PosterImagesRepository
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
    
    
    init(
        searchMoviesUseCase: SearchMoviesUseCase,
        posterImagesRepository: PosterImagesRepository,
        moviesQueriesVM: DefaultMoviesQueriesVM,
        moviesSceneBuilder: MoviesSceneBuilder,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.posterImagesRepository = posterImagesRepository
        self.loadNextPageCoordinator = LoadNextPageCoordinator(currentPage: 0, totalPageCount: 1)
        self.moviesQueriesVM = moviesQueriesVM
        self.sceneBuilder = moviesSceneBuilder
        self.mainQueue = mainQueue
    }
    
    
    // MARK: - MoviesSearchVM
    
    func didSearch(text searchText: String) {
        resetSearch(forText: searchText)
    }
    
    func didCancelSearch() {
        moviesLoadTask?.cancel()
        resetSearch(forText: "")
        loadingState = .none
    }
    
    func didLoadNextPage() {
        guard loadNextPageCoordinator.hasNextPage,
                loadingState == .none
        else { return }
        
        searchMovies(forText: searchText,
                     loadingState: .nextPage)
    }
    
    func didSelectItem(at index: Int) -> MovieDetailsScreen<DefaultMovieDetailsVM> {
        let movie = pages.movies[index]
        return sceneBuilder.makeMovieDetailsScreen(movie: movie)
    }
    
    
    // MARK: - Private
    
    private func resetSearch(forText searchText: String) {
        pages.removeAll()
        items.removeAll()
        loadNextPageCoordinator.update(currentPage: 0, totalPageCount: 1)
        
        guard !searchText.isEmpty else { return }

        searchMovies(forText: searchText, loadingState: .firstPage)
    }
    
    private func searchMovies(forText searchText: String, loadingState: ViewModelLoadingState) {
        self.loadingState = loadingState
        self.searchText = searchText
        
        let requestValue = SearchMoviesUseCaseRequestValue(
            searchText: searchText,
            page: loadNextPageCoordinator.nextPage
        )
        
        moviesLoadTask = searchMoviesUseCase.execute(
            requestValue: requestValue,
            completion: { [weak self] result in
                self?.mainQueue.async {
                    switch result {
                    case .success(let moviesPage):
                        self?.appendPage(moviesPage)
                    case .failure(let error):
                        self?.handle(error: error)
                    }
                }
        })
    }

    private func appendPage(_ moviesPage: MoviesPage) {
        loadNextPageCoordinator.update(
            currentPage: moviesPage.page,
            totalPageCount: moviesPage.totalPages
        )
        
        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]
        
        items = pages.movies.map {
            MovieCellVM(movie: $0, posterImagesRepository: posterImagesRepository)
        }
        
        if moviesPage.movies.count > 0 {
            loadingState = .none
        } else {
            loadingState = .emptyPage
        }
        
        moviesQueriesVM.updateMoviesQueries()
    }

    private func handle(error: Error) {
        errorMessage = "Failed to load movies."
        showAlert = true
        loadingState = .none
    }
}


// MARK: - Private extensions

private extension Array where Element == MoviesPage {
    var movies: [Movie] { flatMap { $0.movies } }
}
