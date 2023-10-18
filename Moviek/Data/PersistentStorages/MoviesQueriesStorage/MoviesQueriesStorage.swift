
import Foundation

protocol MoviesQueriesStorage {
    func saveRecentQuery(movieQuery: MovieQuery) async throws -> MovieQuery
    
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery]
}
