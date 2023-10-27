
import XCTest
@testable import Moviek

final class MoviekUITests: XCTestCase {

    private var app: XCUIApplication!
    
    private var screen: MoviesSearchScreenElements {
        MoviesSearchScreenElements(app: app)
    }
    
    override func setUp() {
        super.setUp()
        
        app = .init()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        
        app = nil
    }
    
    func test_whenSearchMovieAndTapOnFirstResultRow_thenOpenMovieDetails() {
        // When
        screen.searchField.tap()
        screen.searchField.typeText("Star Wars")
        screen.keyboardSearchButton.tap()

        let resultsExpectation = XCTKVOExpectation(
            keyPath: "self.exists",
            object: screen.firstListCell,
            expectedValue: true
        )
        
        let result = XCTWaiter().wait(for: [resultsExpectation], timeout: 5.0)
        XCTAssertEqual(result, .completed)
        screen.firstListCell.tap()
        
        // Then
        XCTAssertNotNil(app.otherElements[AccessibilityIdentifier.movieDetailsScreen])
    }
}
