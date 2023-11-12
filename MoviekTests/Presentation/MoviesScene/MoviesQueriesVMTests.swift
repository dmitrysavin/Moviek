
import Foundation
import XCTest
@testable import Moviek

class MoviesQueriesVMTests: XCTestCase {

    var useCase: MoviesQueriesUseCaseMock!
    var sut: DefaultMoviesQueriesVM!
    
    
    private enum MoviesQueriesVMError: Error {
        case testError
    }
    
    var moviesQueries = [MovieQuery(query: "query1"),
                        MovieQuery(query: "query2"),
                        MovieQuery(query: "query3"),
                        MovieQuery(query: "query4"),
                        MovieQuery(query: "query5")]

    override func setUp() {
        super.setUp()
        
        useCase = MoviesQueriesUseCaseMock()

        sut = DefaultMoviesQueriesVM(
            searchMoviesUseCase: useCase,
            numberOfQueriesToShow: 3
        )
    }

    override func tearDown() {
        super.tearDown()
        
        useCase = nil
        sut = nil
    }
    
    func testFetch_whenQueriesExist_thenContainsExistingQueries() async {
        // Given
        useCase._execute = { requestValue in
            return self.moviesQueries
        }

        // When
        await sut.fetch()
        
        // Then
        XCTAssertEqual(sut.items, moviesQueries.map { $0.query }, "DefaultMoviesQueriesVM should contain existing queries.")
    }
    
    func testFetch_whenTriggersError_thenDoesNotContainQueries() async {
        // Given
        useCase._execute = { requestValue in
            throw MoviesQueriesVMError.testError
        }

        // When
        await sut.fetch()
        
        // Then
        XCTAssertTrue(sut.items.isEmpty, "DefaultMoviesQueriesVM should not contain queries if the fetch finished with an error.")
    }
}


extension MoviesQueriesVMTests {

    class MoviesQueriesUseCaseMock: MoviesQueriesUseCase {

        lazy var _execute: (Int) async throws -> [MovieQuery] = { maxCount in
            XCTFail("_execute closure is not implemented.")
            return [MovieQuery(query: "")]
        }
        
        func execute(
            maxCount: Int
        ) async throws -> [MovieQuery] {
            return try await _execute(maxCount)
        }
    }
}
