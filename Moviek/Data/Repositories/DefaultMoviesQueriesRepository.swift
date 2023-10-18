
import Foundation

final class DefaultMoviesQueriesRepository: MoviesQueriesRepository {
    
    // MARK: - Private properties
    private var moviesQueriesStorage: MoviesQueriesStorage
    
    
    // MARK: - Exposed methods
    init(moviesQueriesPersistentStorage: MoviesQueriesStorage) {
        self.moviesQueriesStorage = moviesQueriesPersistentStorage
    }
    
    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery {
        return try await moviesQueriesStorage.saveRecentQuery(movieQuery: query)
    }
    
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
        return try await moviesQueriesStorage.fetchRecentsQueries(maxCount: maxCount)
    }
}
