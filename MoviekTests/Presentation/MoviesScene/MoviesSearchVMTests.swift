
import Foundation
import XCTest
@testable import Moviek

class MoviesSearchVMTests: XCTestCase {
    
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
    
    func test_whenSearchMoviesUseCaseRetrievesEmptyPage_thenViewModelIsEmpty() async {
        // given
        let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return MoviesPage(page: 1, totalPages: 2, movies: [])
        }
        
        let viewModel = DefaultMoviesVM(searchMoviesUseCase: searchMoviesUseCaseMock)
        
        // when
        await viewModel.didSearch(text: "query")
        
        // then
        XCTAssertEqual(viewModel.loadingState, .emptyPage)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_whenSearchMoviesUseCaseRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() async {
        // given
        let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        let viewModel = DefaultMoviesVM(searchMoviesUseCase: searchMoviesUseCaseMock)
        
        // when
        await viewModel.didSearch(text: "query")
        
        // then
        let expectedItems = moviesPages[0]
            .movies
            .map { MovieCellVM(movie: $0) }
        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_whenSearchMoviesUseCaseRetrievesFirstAndSecondPage_thenViewModelContainsTwoPages() async {
        // given
        let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        let viewModel = DefaultMoviesVM(searchMoviesUseCase: searchMoviesUseCaseMock)
        
        // when
        await viewModel.didSearch(text: "query")
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 1)
        
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 2)
            return self.moviesPages[1]
        }
        
        await viewModel.didLoadNextPage()
        
        // then
        let expectedItems = moviesPages
            .flatMap { $0.movies }
            .map { MovieCellVM(movie: $0) }
        XCTAssertEqual(viewModel.items, expectedItems)
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 2)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_whenSearchMoviesUseCaseReturnsError_thenViewModelContainsError() async {
        // given
        let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            throw MoviesSearchVMError.testError
        }
        
        let viewModel = DefaultMoviesVM(searchMoviesUseCase: searchMoviesUseCaseMock)
        
        // when
        await viewModel.didSearch(text: "query")
        
        // then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_whenLastPage_thenSearchMoviesUseCaseNotExecuted() async {
        // given
        let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        let viewModel = DefaultMoviesVM(searchMoviesUseCase: searchMoviesUseCaseMock)
        
        // when
        await viewModel.didSearch(text: "query")
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 1)
        
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 2)
            return self.moviesPages[1]
        }
        
        await viewModel.didLoadNextPage()
        await viewModel.didLoadNextPage()
        
        // then
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 2)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
    }
    
    func test_whenSearchMoviesUseCaseRetrievesFirstPageAndViewModelDidCancel_thenViewModelIsEmpty() async {
        // given
        let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
        searchMoviesUseCaseMock._execute = { requestValue in
            XCTAssertEqual(requestValue.page, 1)
            return self.moviesPages[0]
        }
        
        let viewModel = DefaultMoviesVM(searchMoviesUseCase: searchMoviesUseCaseMock)
        
        // when
        await viewModel.didSearch(text: "query")
        await viewModel.didCancelSearch()
        
        // then
        XCTAssertEqual(viewModel.loadingState, .none)
        XCTAssertTrue(viewModel.items.isEmpty)
        XCTAssertEqual(searchMoviesUseCaseMock.executeCallCount, 1)
        addTeardownBlock { [weak viewModel] in XCTAssertNil(viewModel) }
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
