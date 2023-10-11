
import Foundation

struct MoviesQueriesUseCaseRequestValue {
    let maxCount: Int
}

protocol MoviesQueriesUseCase {
    func execute(
        requestValue: MoviesQueriesUseCaseRequestValue,
        completion: @escaping (Result<[MovieQuery], Error>) -> Void
    ) -> Cancellable?
}

struct DefaultMoviesQueriesUseCase: MoviesQueriesUseCase {

    // MARK: - Private properties
    private let moviesQueriesRepository: MoviesQueriesRepository

    
    // MARK: - Exposed methods
    init(moviesQueriesRepository: MoviesQueriesRepository) {
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func execute(
        requestValue: MoviesQueriesUseCaseRequestValue,
        completion: @escaping (Result<[MovieQuery], Error>) -> Void
    ) -> Cancellable? {

        moviesQueriesRepository.fetchRecentsQueries(
            maxCount: requestValue.maxCount,
            completion: completion
        )
        
        return nil
    }
}
