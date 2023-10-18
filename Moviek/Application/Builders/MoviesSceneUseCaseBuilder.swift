
import Foundation

struct MoviesSceneUseCaseBuilder {
        
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
        let storage = SwiftDataMoviesQueriesStorage(maxStorageLimit: 10)
        return DefaultMoviesQueriesRepository(moviesQueriesPersistentStorage: storage)
    }
    
    
    // MARK: - Movies Queries View
    func makeMoviesQueriesUseCase() -> MoviesQueriesUseCase {
        let repository = makeMoviesQueriesRepository()
        return DefaultMoviesQueriesUseCase(moviesQueriesRepository: repository)
    }
}
