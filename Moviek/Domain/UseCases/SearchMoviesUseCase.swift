
import Foundation

struct SearchMoviesUseCaseRequestValue {
    let searchText: String
    let page: Int
}

protocol SearchMoviesUseCase {
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
        
    // MARK: - Private properties
    
    private let moviesRepository: MoviesRepository
    private let moviesQueriesRepository: MoviesQueriesRepository
    
    
    // MARK: - Exposed methods
    
    init(
        moviesRepository: MoviesRepository,
        moviesQueriesRepository: MoviesQueriesRepository
    ) {
        self.moviesRepository = moviesRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable? {
    
        let movieQuery = MovieQuery(query: requestValue.searchText)
        
        return moviesRepository.fetchMovies(
            searchText: requestValue.searchText,
            page: requestValue.page
        ) { moviesPageResult in
            
            if case .success = moviesPageResult {
                self.moviesQueriesRepository.saveRecentQuery(query: movieQuery) { movieQueryResult in
                    completion(moviesPageResult)
                }
            } else {
                completion(moviesPageResult)
            }
        }
    }
}
