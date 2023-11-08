
import SwiftUI

struct MoviesSceneBuilder {

    // MARK: - Exposed properties
    private let useCaseBuilder: MoviesSceneUseCaseBuilder
    
    
    // MARK: - Exposed methods
    init(useCaseBuilder: MoviesSceneUseCaseBuilder = MoviesSceneUseCaseBuilder()) {
        self.useCaseBuilder = useCaseBuilder
    }
    
    
    // MARK: - Movies Search Screen
    func makeMoviesSearchScreen() -> MoviesSearchScreen<DefaultMoviesVM> {
        let useCase = useCaseBuilder.makeSearchMoviesUseCase()
        let vm = DefaultMoviesVM(searchMoviesUseCase: useCase)
        return MoviesSearchScreen(viewModel: vm)
    }
    
    
    // MARK: - Moviey Details Screen
    func makeMovieDetailsScreen(movie: Movie) -> MovieDetailsScreen<DefaultMovieDetailsVM> {
        let vm = DefaultMovieDetailsVM(movie: movie)
        return MovieDetailsScreen(viewModel: vm)
    }
    
    
    // MARK: - Movies Queries View
    func makeMoviesQueriesView(onTap: @escaping (String) -> Void) -> some View {
        let useCase = useCaseBuilder.makeMoviesQueriesUseCase()
        let vm = DefaultMoviesQueriesVM(searchMoviesUseCase: useCase)
        return MoviesQueriesView(viewModel: vm, onTap: onTap)
    }
}
