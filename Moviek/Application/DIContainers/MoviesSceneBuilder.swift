
import SwiftUI

final class MoviesSceneBuilder {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imagesBasePath: String
    }

    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    
    // MARK: - Movies Search Screen
    
    func makeMoviesSearchScreen() -> some View {
        let useCase = makeSearchMoviesUseCase()
        let repository = makePosterImagesRepository()
        
        let screenBuilder = DefaultMoviesVM.ScreenBuilder(
            movieDetails: makeMovieDetailsScreen
        )
        
        let moviesQueriesVM = makeMoviesQueriesVM()
        
        let vm = DefaultMoviesVM(
            screenBuilder: screenBuilder,
            searchMoviesUseCase: useCase,
            posterImagesRepository: repository,
            moviesQueriesVM: moviesQueriesVM
        )
        
        return MoviesSearchScreen(viewModel: vm)
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
            dataTransferService: dependencies.apiDataTransferService
        )
    }

    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        let storage = UserDefaultsMoviesQueriesStorage(maxStorageLimit: 10)
        let repository = DefaultMoviesQueriesRepository(moviesQueriesPersistentStorage: storage)
        return repository
    }
    
    func makePosterImagesRepository() -> PosterImagesRepository {
        let path = dependencies.imagesBasePath
        return DefaultPosterImagesRepository(imagesBasePath: path)
    }
    
    
    // MARK: - Moviey Details Screen
    
    lazy var makeMovieDetailsScreen: (Movie) -> MovieDetailsScreen<DefaultMovieDetailsVM> = { [weak self] (movie) in
        
        guard let self = self else {
            fatalError("The instance was deallocated before the closure was called.")
        }
        
        let repository = self.makePosterImagesRepository()
        let vm = DefaultMovieDetailsVM(
            movie: movie,
            posterImagesRepository: repository
        )
        
        return MovieDetailsScreen(viewModel: vm)
    }
    
    
    // MARK: - Movies Queries View
    
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
