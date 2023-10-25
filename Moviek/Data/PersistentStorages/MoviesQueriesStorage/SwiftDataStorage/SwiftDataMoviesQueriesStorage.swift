
import Foundation
import SwiftData

final class SwiftDataMoviesQueriesStorage: MoviesQueriesStorage {
    
    // MARK: - Private properties
    private let maxStorageLimit: Int
    private let swiftDataStorage: SwiftDataStorage

    
    // MARK: - Exposed methods
    init(
        maxStorageLimit: Int,
        swiftDataStorage: SwiftDataStorage = AppDIContainer.swiftDataStorage
    ) {
        self.maxStorageLimit = maxStorageLimit
        self.swiftDataStorage = swiftDataStorage
    }

    func saveRecentQuery(movieQuery: MovieQuery) async throws -> MovieQuery {
        let exists = try await isExistingQuery(movieQuery: movieQuery)
        guard !exists else {
            return movieQuery
        }

        try await removeQueries(limit: maxStorageLimit - 1)
        
        let queryEntity = MovieQueryEntity(query: movieQuery.query)
        swiftDataStorage.save(queryEntity)
        return movieQuery
    }

    func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
        let movieQueriesEntities: [MovieQueryEntity] = try swiftDataStorage.fetch()
        return movieQueriesEntities.map { $0.toDomain() }
    }
    
    
    // MARK: - Private methods
    private func isExistingQuery(movieQuery: MovieQuery) async throws -> Bool {
        let recentQueries = try await fetchRecentsQueries(maxCount: Int.max)
        return recentQueries.contains { $0.query == movieQuery.query }
    }
    
    private func removeQueries(limit: Int) async throws {
        let recentQueries: [MovieQueryEntity] = try swiftDataStorage.fetch()

        if recentQueries.count > limit {
            let queriesToRemove = Array(recentQueries.suffix(recentQueries.count - limit))

            swiftDataStorage.delete(queriesToRemove)
        }
    }
}
