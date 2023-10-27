
import XCTest

class MoviesSearchScreenElements {

    // MARK: - Exposed properties
    var searchField: XCUIElement {
        return app.navigationBars[localizedString("find_your_movie")].searchFields[localizedString("search...")]
    }
    
    var keyboardSearchButton: XCUIElement {
        app.keyboards.buttons[localizedString("search")]
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
