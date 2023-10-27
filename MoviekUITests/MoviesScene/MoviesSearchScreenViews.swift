
import XCTest

class MoviesSearchScreenViews {

    // MARK: - Exposed properties
    var searchField: XCUIElement {
        app.navigationBars["Find your movie"].searchFields["Search..."]
    }
    
    var keyboardSearchButton: XCUIElement {
        app.keyboards.buttons["Search"]
    }
    
    var firstListCell: XCUIElement {
        let collectionView = app.collectionViews
        return collectionView.cells.element(boundBy: 0)
    }
    
    
    // MARK: - Private properties
    private let app: XCUIApplication
    
    
    // MARK: - Exposed methods
    init(app: XCUIApplication) {
        self.app = app
    }
}
