
import Foundation

protocol MoviesQueriesRepository {
    func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery
    
    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery]
}
