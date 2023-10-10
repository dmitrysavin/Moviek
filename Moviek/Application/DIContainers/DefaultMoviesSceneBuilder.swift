
import SwiftUI

protocol MoviesSceneBuilder {
    associatedtype MovieDetailsVMType: MovieDetailsVM
    func makeMovieDetailsScreen(movie: Movie) -> MovieDetailsScreen<MovieDetailsVMType>
}

final class DefaultMoviesSceneBuilder: MoviesSceneBuilder {

    let apiDataTransferService: DataTransferService
    let imageDataTransferService: DataTransferService
    
    init(
        apiDataTransferService: DataTransferService = AppDIContainer.apiDataTransferService,
        imageDataTransferService: DataTransferService = AppDIContainer.imageDataTransferService
    ) {
        self.apiDataTransferService = apiDataTransferService
        self.imageDataTransferService = imageDataTransferService
    }
    
    // MARK: - Movies Search Screen
    
    func makeMoviesSearchScreen() -> MoviesSearchScreen<DefaultMoviesVM> {
        let useCase = makeSearchMoviesUseCase()
        
        let vm = DefaultMoviesVM(
            searchMoviesUseCase: useCase
        )
        
        let screen = MoviesSearchScreen(
            viewModel: vm,
            moviesSceneBuilder: self
        )
        
        return screen
    }
    
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        let moviesRepository = makeMoviesRepository()
        let moviesQueriesRepository = makeMoviesQueriesRepository()
        let useCase = DefaultSearchMoviesUseCase(
            moviesRepository: moviesRepository,
            moviesQueriesRepository: moviesQueriesRepository
        )
        return useCase
    }
    
    func makeMoviesRepository() -> MoviesRepository {
        DefaultMoviesRepository(
            dataTransferService: apiDataTransferService
        )
    }

    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        let storage = UserDefaultsMoviesQueriesStorage(maxStorageLimit: 10)
        let repository = DefaultMoviesQueriesRepository(moviesQueriesPersistentStorage: storage)
        return repository
    }
        
    
    // MARK: - Moviey Details Screen
    
    func makeMovieDetailsScreen(movie: Movie) -> MovieDetailsScreen<DefaultMovieDetailsVM> {
        let vm = DefaultMovieDetailsVM(movie: movie)
        return MovieDetailsScreen(viewModel: vm)
    }
    
    
    // MARK: - Movies Queries View
    
    func makeMoviesQueriesView(onTap: @escaping (MoviesQueryCellVM) -> Void) -> some View {
        let vm = makeMoviesQueriesVM()
        var view = MoviesQueriesView(viewModel: vm)
        view.onTap = onTap
        
        return view
    }
    
    func makeMoviesQueriesVM() -> DefaultMoviesQueriesVM {
        let useCase = makeMoviesQueriesUseCase()
        return DefaultMoviesQueriesVM(searchMoviesUseCase: useCase)
    }
    
    func makeMoviesQueriesUseCase() -> MoviesQueriesUseCase {
        let repository = makeMoviesQueriesRepository()
        let useCase = DefaultMoviesQueriesUseCase(moviesQueriesRepository: repository)
        return useCase
    }
}
