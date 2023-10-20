
import Foundation
import SwiftUI

protocol MoviesVMInput {
    func didSearch(text searchText: String) async
    func didCancelSearch() async
    func didLoadNextPage() async
    func movieDetailsScreen(
        forMovieIndex index: Int,
        builder: MoviesSceneBuilder) -> MovieDetailsScreen<DefaultMovieDetailsVM>
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
    private let loadNextPageManager: LoadNextPageHelper
    
    
    // MARK: - Exposed methods
    init(searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.loadNextPageManager = LoadNextPageHelper(currentPage: 0, totalPageCount: 1)
    }
    
    func didSearch(text searchText: String) async {
        await resetSearch(forText: searchText)
    }
    
    @MainActor func didCancelSearch() async {
        await resetSearch(forText: "")
        loadingState = .none
    }
    
    @MainActor func didLoadNextPage() async {
        guard loadNextPageManager.hasNextPage,
                loadingState == .none
        else { return }
        
        await searchMovies(forText: searchText,
                     loadingState: .nextPage)
    }
    
    func movieDetailsScreen(
        forMovieIndex index: Int,
        builder: MoviesSceneBuilder) -> MovieDetailsScreen<DefaultMovieDetailsVM> {
        
        let movie = pages.movies[index]
        return builder.makeMovieDetailsScreen(movie: movie)
    }

    
    // MARK: - Private methods
    @MainActor private func resetSearch(forText searchText: String) async {
        pages.removeAll()
        items.removeAll()
        loadNextPageManager.update(currentPage: 0, totalPageCount: 1)
        
        guard !searchText.isEmpty else { return }

        await searchMovies(forText: searchText, loadingState: .firstPage)
    }
    
    @MainActor private func searchMovies(
        forText searchText: String,
        loadingState: ViewModelLoadingState
    ) async {
        self.loadingState = loadingState
        self.searchText = searchText

        let requestValue = SearchMoviesUseCaseRequestValue(
            searchText: searchText,
            page: loadNextPageManager.nextPage
        )

        Task {
            do {
                let moviesPage = try await searchMoviesUseCase.execute(requestValue: requestValue)
                    if (requestValue.searchText == searchText) {
                        appendPage(moviesPage)
                    }
            } catch {
                handle(error: error)
            }
        }
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
