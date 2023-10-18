
import Foundation

struct MoviesQueriesUseCaseRequestValue {
    let maxCount: Int
}

protocol MoviesQueriesUseCase {
    func execute(
        requestValue: MoviesQueriesUseCaseRequestValue
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
        requestValue: MoviesQueriesUseCaseRequestValue
    ) async throws -> [MovieQuery] {
        return try await moviesQueriesRepository.fetchRecentsQueries(maxCount: requestValue.maxCount)
    }
}
