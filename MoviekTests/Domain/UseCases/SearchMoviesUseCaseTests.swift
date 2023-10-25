
import Foundation
import XCTest
@testable import Moviek

class SearchMoviesUseCaseTests: XCTestCase {

    enum MoviesRepositoryError: Error {
        case testError
    }

    let moviesPages: [MoviesPage] = {
        let page1 = MoviesPage(page: 1, totalPages: 2, movies: [
            Movie.stub(id: "1", title: "title1", posterPath: "/1", overview: "overview1"),
            Movie.stub(id: "2", title: "title2", posterPath: "/2", overview: "overview2")
        ])
        
        let page2 = MoviesPage(page: 2, totalPages: 2, movies: [
            Movie.stub(id: "3", title: "title3", posterPath: "/3", overview: "overview3")
        ])
        
        return [page1, page2]
    }()

    func testSearchMoviesUseCase_whenSuccessfullyFetchesMoviesForQuery_thenQueryIsSavedInRecentQueries() async {
        // Given
        let moviesQueriesRepository = MoviesQueriesRepositoryMock()
        let moviesRepository = MoviesRepositoryMock()
        moviesRepository._fetchMovies = { searchText, page in
            return self.moviesPages[0]
        }

        let useCase = DefaultSearchMoviesUseCase(moviesRepository: moviesRepository,
                                                 moviesQueriesRepository: moviesQueriesRepository)
        
        // When
        let requestValue = SearchMoviesUseCaseRequestValue(searchText: "title1", page: 0)
        do {
            _ = try await useCase.execute(requestValue: requestValue)
        } catch {}
        
        // Then
        var recentQueries = [MovieQuery]()
        do {
            recentQueries = try await moviesQueriesRepository.fetchRecentsQueries(maxCount: 1)
        } catch {}
        
        XCTAssertTrue(recentQueries.contains(MovieQuery(query: "title1")))
        XCTAssertEqual(moviesQueriesRepository.fetchCallsCount, 1)
        XCTAssertEqual(moviesRepository.fetchCallsCount, 1)
    }
    
    func testSearchMoviesUseCase_whenFailedFetchingMoviesForQuery_thenQueryIsNotSavedInRecentQueries() async {
        // Given
        let moviesQueriesRepository = MoviesQueriesRepositoryMock()
        let moviesRepository = MoviesRepositoryMock()
        moviesRepository._fetchMovies = { searchText, page in
            throw MoviesRepositoryError.testError
        }

        let useCase = DefaultSearchMoviesUseCase(moviesRepository: moviesRepository,
                                                 moviesQueriesRepository: moviesQueriesRepository)
        
        // When
        let requestValue = SearchMoviesUseCaseRequestValue(searchText: "title1", page: 0)
        do {
            _ = try await useCase.execute(requestValue: requestValue)
        } catch {}
        
        // Then
        var recentQueries = [MovieQuery]()
        do {
            recentQueries = try await moviesQueriesRepository.fetchRecentsQueries(maxCount: 1)
        } catch {}
        
        XCTAssertTrue(recentQueries.isEmpty)
        XCTAssertEqual(moviesQueriesRepository.fetchCallsCount, 1)
        XCTAssertEqual(moviesRepository.fetchCallsCount, 1)
    }
}


extension SearchMoviesUseCaseTests {

    class MoviesRepositoryMock: MoviesRepository {
        var fetchCallsCount: Int = 0
        
        lazy var _fetchMovies: (String, Int) async throws -> MoviesPage = { searchText, page in
            XCTFail("_execute closure is not implemented.")
            return MoviesPage(page: 0, totalPages: 0, movies: [])
        }
        
        func fetchMovies(
            searchText: String,
            page: Int) async throws -> MoviesPage {
                fetchCallsCount += 1
                return try await _fetchMovies(searchText, page)
            }
    }
    
    final class MoviesQueriesRepositoryMock: MoviesQueriesRepository {
        var recentQueries: [MovieQuery] = []
        var fetchCallsCount = 0
        var _saveRecentQueryClosure: ((MovieQuery) async throws -> MovieQuery)?

        func saveRecentQuery(query: MovieQuery) async throws -> MovieQuery {
            if let saveQuery = _saveRecentQueryClosure {
                return try await saveQuery(query)
            } else {
                recentQueries.append(query)
                return query
            }
        }
        
        func fetchRecentsQueries(maxCount: Int) async throws -> [MovieQuery] {
            fetchCallsCount += 1
            return recentQueries
        }
    }
}
