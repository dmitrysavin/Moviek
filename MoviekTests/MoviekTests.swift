
import XCTest
@testable import Moviek

class DefaultMoviesVMTests: XCTestCase {
    
    func testDidSearch() async {
        let movies = [Movie.mock, Movie.mock, Movie.mock, Movie.mock, Movie.mock]
        let mockPage = MoviesPage(page: 1, totalPages: 1, movies: movies)
        let searchUseCase = MockSearchMoviesUseCase(mockMoviesPage: mockPage)
        let moviesVM = DefaultMoviesVM(searchMoviesUseCase: searchUseCase)

        let expectation = XCTestExpectation(description: "Search movies")

        print("1")
        Task {
            print("3")
            await moviesVM.didSearch(text: "Action")
            print("4")
            expectation.fulfill()
            print("5")
        }

        print("2")
        // Wait for the expectation to be fulfilled, with a timeout of 5 seconds (adjust as needed)
        wait(for: [expectation], timeout: 5)
        
        print("6")
        print("items = \(moviesVM.items.count)")
        XCTAssertGreaterThan(moviesVM.items.count, 0)
    }
}


class MockSearchMoviesUseCase: SearchMoviesUseCase {

    let mockMoviesPage: MoviesPage

    init(mockMoviesPage: MoviesPage) {
        self.mockMoviesPage = mockMoviesPage
    }

    func execute(requestValue: SearchMoviesUseCaseRequestValue) async throws -> MoviesPage {
        return mockMoviesPage
    }
}
