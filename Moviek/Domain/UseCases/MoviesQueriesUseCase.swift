
import Foundation

protocol MoviesQueriesUseCase {
    func execute(
        maxCount: Int
    ) async throws -> [MovieQuery]
}

struct DefaultMoviesQueriesUseCase: MoviesQueriesUseCase {

    // MARK: - Private properties
    private let moviesQueriesRepository: MoviesQueriesRepository

    
    // MARK: - Exposed methods
    init(moviesQueriesRepository: MoviesQueriesRepository) {
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func execute(
        maxCount: Int
    ) async throws -> [MovieQuery] {
        let movieQueries = try await moviesQueriesRepository.fetchRecentsQueries(maxCount: maxCount)
        return movieQueries.reversed()
    }
}
