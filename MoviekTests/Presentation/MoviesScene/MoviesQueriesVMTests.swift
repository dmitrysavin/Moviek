
import Foundation
import XCTest
@testable import Moviek

class MoviesQueriesVMTests: XCTestCase {

    private enum MoviesQueriesVMError: Error {
        case testError
    }
    
    var moviesQueries = [MovieQuery(query: "query1"),
                        MovieQuery(query: "query2"),
                        MovieQuery(query: "query3"),
                        MovieQuery(query: "query4"),
                        MovieQuery(query: "query5")]

    func test_whenMoviesQueriesUseCaseUpdatesQueries_thenShowTheseQueries() async {
        // given
        let useCase = MoviesQueriesUseCaseMock()
        useCase._execute = { requestValue in
            return self.moviesQueries
        }

        let viewModel = DefaultMoviesQueriesVM(
            searchMoviesUseCase: useCase,
            numberOfQueriesToShow: 3
        )

        // when
        await viewModel.updateMoviesQueries()
        
        // then
        XCTAssertEqual(viewModel.items.map { $0.query }, moviesQueries.map { $0.query })
        XCTAssertEqual(useCase.executeCallCount, 1)
    }
    
    func test_whenFetchRecentMovieQueriesUseCaseReturnsError_thenDontShowAnyQuery() async {
        // given
        let useCase = MoviesQueriesUseCaseMock()
        useCase._execute = { requestValue in
            throw MoviesQueriesVMError.testError
        }

        let viewModel = DefaultMoviesQueriesVM(
            searchMoviesUseCase: useCase,
            numberOfQueriesToShow: 3
        )

        // when
        await viewModel.updateMoviesQueries()
        
        // then
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(useCase.executeCallCount, 1)
    }

}


extension MoviesQueriesVMTests {

    class MoviesQueriesUseCaseMock: MoviesQueriesUseCase {
        var executeCallCount: Int = 0

        lazy var _execute: (MoviesQueriesUseCaseRequestValue) async throws -> [MovieQuery] = { requestValue in
            XCTFail("_execute closure is not implemented.")
            return [MovieQuery(query: "")]
        }
        
        func execute(
            requestValue: MoviesQueriesUseCaseRequestValue
        ) async throws -> [MovieQuery] {
            executeCallCount += 1
            return try await _execute(requestValue)
        }
    }
}
