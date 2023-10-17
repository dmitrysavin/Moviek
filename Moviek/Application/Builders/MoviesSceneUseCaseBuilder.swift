
import Foundation

struct MoviesSceneUseCaseBuilder {
    
    // MARK: - Exposed properties
    let apiDataTransferService: DataTransferService
    
    
    // MARK: - Exposed methods
    init(apiDataTransferService: DataTransferService = AppDIContainer.apiDataTransferService) {
        self.apiDataTransferService = apiDataTransferService
    }
    
    
    // MARK: - Movies Search Screen
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        let moviesRepository = makeMoviesRepository()
        let moviesQueriesRepository = makeMoviesQueriesRepository()
        return DefaultSearchMoviesUseCase(
            moviesRepository: moviesRepository,
            moviesQueriesRepository: moviesQueriesRepository
        )
    }
    
    func makeMoviesRepository() -> MoviesRepository {
        DefaultMoviesRepository()
    }

    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        let storage = UserDefaultsMoviesQueriesStorage(maxStorageLimit: 10)
        return DefaultMoviesQueriesRepository(moviesQueriesPersistentStorage: storage)
    }
    
    
    // MARK: - Movies Queries View
    func makeMoviesQueriesUseCase() -> MoviesQueriesUseCase {
        let repository = makeMoviesQueriesRepository()
        return DefaultMoviesQueriesUseCase(moviesQueriesRepository: repository)
    }
}
