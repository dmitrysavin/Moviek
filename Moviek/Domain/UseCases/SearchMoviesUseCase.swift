
import Foundation

struct SearchMoviesUseCaseRequestValue {
    let searchText: String
    let page: Int
}

protocol SearchMoviesUseCase {
    func execute(requestValue: SearchMoviesUseCaseRequestValue) async throws -> MoviesPage
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
    
    func execute(requestValue: SearchMoviesUseCaseRequestValue) async throws -> MoviesPage {
        do {
            let moviesPage = try await moviesRepository.fetchMovies(
                searchText: requestValue.searchText,
                page: requestValue.page)

            let movieQuery = MovieQuery(query: requestValue.searchText)
            _ = try await self.moviesQueriesRepository.saveRecentQuery(query: movieQuery)
            
            return moviesPage
        } catch {
            throw error
        }
    }
}
