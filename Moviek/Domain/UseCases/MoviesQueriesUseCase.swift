
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

    private let moviesQueriesRepository: MoviesQueriesRepository

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
