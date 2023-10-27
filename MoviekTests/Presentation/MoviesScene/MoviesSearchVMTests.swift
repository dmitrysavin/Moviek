
import Foundation
import XCTest
@testable import Moviek

class MoviesSearchVMTests: XCTestCase {
    
    var useCase: SearchMoviesUseCaseMock!
    var viewModel: DefaultMoviesVM!
    
    private enum MoviesSearchVMError: Error {
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
    
    override func setUp() {
        super.setUp()
        
        useCase = SearchMoviesUseCaseMock()
        viewModel = DefaultMoviesVM(searchMoviesUseCase: useCase)
    }

    override func tearDown() {
        super.tearDown()
        
        useCase = nil
        viewModel = nil
    }
    
    func test_whenSearchMoviesUseCaseRetrievesEmptyPage_thenViewModelIsEmpty() async {
        // Given
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return MoviesPage(page: 1, totalPages: 2, movies: [])
        }
        
        // When
        await viewModel.didSearch(text: "query")
        
        // Then
        XCTAssertEqual(viewModel.loadingState, .emptyPage)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(useCase.executeCallCount, 1)
    }
    
    func test_whenSearchMoviesUseCaseRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() async {
        // Given
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        // When
        await viewModel.didSearch(text: "query")
        
        // Then
        let expectedItems = moviesPages[0]
            .movies
            .map { MovieCellVM(movie: $0) }
        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(useCase.executeCallCount, 1)
    }
    
    func test_whenSearchMoviesUseCaseRetrievesFirstAndSecondPage_thenViewModelContainsTwoPages() async {
        // Given
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        // When
        await viewModel.didSearch(text: "query")
        XCTAssertEqual(useCase.executeCallCount, 1)
        
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 2)
            return self.moviesPages[1]
        }
        
        await viewModel.didLoadNextPage()
        
        // Then
        let expectedItems = moviesPages
            .flatMap { $0.movies }
            .map { MovieCellVM(movie: $0) }
        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(useCase.executeCallCount, 2)
    }
    
    func test_whenSearchMoviesUseCaseReturnsError_thenViewModelContainsError() async {
        // Given
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            throw MoviesSearchVMError.testError
        }
        
        // When
        await viewModel.didSearch(text: "query")
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(useCase.executeCallCount, 1)
    }
    
    func test_whenLastPage_thenSearchMoviesUseCaseNotExecuted() async {
        // Given
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        // When
        await viewModel.didSearch(text: "query")
        XCTAssertEqual(useCase.executeCallCount, 1)
        
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 2)
            return self.moviesPages[1]
        }
        
        await viewModel.didLoadNextPage()
        await viewModel.didLoadNextPage()
        
        // Then
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(useCase.executeCallCount, 2)
    }
    
    func test_whenSearchMoviesUseCaseRetrievesFirstPageAndViewModelDidCancel_thenViewModelIsEmpty() async {
        // Given
        useCase._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        // When
        await viewModel.didSearch(text: "query")
        await viewModel.didCancelSearch()
        
        // Then
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(useCase.executeCallCount, 1)
    }
}


extension MoviesSearchVMTests {

    class SearchMoviesUseCaseMock: SearchMoviesUseCase {
        var executeCallCount: Int = 0

        lazy var _execute: (SearchMoviesUseCaseRequestValue) async throws -> MoviesPage = { requestValue in
            XCTFail("_execute closure is not implemented.")
            return MoviesPage(page: 0, totalPages: 0, movies: [])
        }

        func execute(requestValue: SearchMoviesUseCaseRequestValue) async throws -> MoviesPage {
            executeCallCount += 1
            return try await _execute(requestValue)
        }
    }
}
