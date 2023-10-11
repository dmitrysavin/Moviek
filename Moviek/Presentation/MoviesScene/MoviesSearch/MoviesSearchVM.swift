
import Foundation
import SwiftUI

protocol MoviesVMInput {
    func didSearch(text searchText: String)
    func didCancelSearch()
    func didLoadNextPage()
    func movieDetailsScreen(
        forMovieIndex index: Int,
        builder: DefaultMoviesSceneBuilder) -> MovieDetailsScreen<DefaultMovieDetailsVM>
}

protocol MoviesVMOutput {
    var items: [MovieCellVM] { get }
    var searchText: String { get set }
    var loadingState: ViewModelLoadingState { get }
    var showAlert: Bool { get set }
    var errorMessage: String { get }
}

protocol MoviesSearchVM: MoviesVMInput & MoviesVMOutput & ObservableObject {
}

final class DefaultMoviesVM: MoviesSearchVM {

    // MARK: - Exposed properties
    @Published var items: [MovieCellVM] = []
    @Published var searchText: String = ""
    @Published var loadingState: ViewModelLoadingState = .none
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    
    // MARK: - Private properties
    private let searchMoviesUseCase: SearchMoviesUseCase
    private var pages: [MoviesPage] = []
    private let mainQueue: DispatchQueueType
    private let loadNextPageManager: LoadNextPageManager
    private var moviesLoadTask: Cancellable? { willSet { moviesLoadTask?.cancel() } }
    
    
    // MARK: - Exposed methods
    init(
        searchMoviesUseCase: SearchMoviesUseCase,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.loadNextPageManager = LoadNextPageManager(currentPage: 0, totalPageCount: 1)
        self.mainQueue = mainQueue
    }
    
    func didSearch(text searchText: String) {
        resetSearch(forText: searchText)
    }
    
    func didCancelSearch() {
        moviesLoadTask?.cancel()
        resetSearch(forText: "")
        loadingState = .none
    }
    
    func didLoadNextPage() {
        guard loadNextPageManager.hasNextPage,
                loadingState == .none
        else { return }
        
        searchMovies(forText: searchText,
                     loadingState: .nextPage)
    }
    
    func movieDetailsScreen(
        forMovieIndex index: Int,
        builder: DefaultMoviesSceneBuilder) -> MovieDetailsScreen<DefaultMovieDetailsVM> {
        
        let movie = pages.movies[index]
        return builder.makeMovieDetailsScreen(movie: movie)
    }

    
    // MARK: - Private methods
    private func resetSearch(forText searchText: String) {
        pages.removeAll()
        items.removeAll()
        loadNextPageManager.update(currentPage: 0, totalPageCount: 1)
        
        guard !searchText.isEmpty else { return }

        searchMovies(forText: searchText, loadingState: .firstPage)
    }
    
    private func searchMovies(
        forText searchText: String,
        loadingState: ViewModelLoadingState
    ) {
        self.loadingState = loadingState
        self.searchText = searchText
        
        let requestValue = SearchMoviesUseCaseRequestValue(
            searchText: searchText,
            page: loadNextPageManager.nextPage
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
        loadNextPageManager.update(
            currentPage: moviesPage.page,
            totalPageCount: moviesPage.totalPages
        )
        
        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]
        
        items = pages.movies.map {
            MovieCellVM(movie: $0)
        }
        
        if moviesPage.movies.count > 0 {
            loadingState = .none
        } else {
            loadingState = .emptyPage
        }
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
