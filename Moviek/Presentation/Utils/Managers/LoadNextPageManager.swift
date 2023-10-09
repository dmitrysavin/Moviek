
import Foundation

class LoadNextPageManager {

    // MARK: - Exposed properties
    
    var hasNextPage: Bool {
        currentPage < totalPageCount
    }
    
    var nextPage: Int {
        hasNextPage ? currentPage + 1 : currentPage
    }

    
    // MARK: - Private properties
    
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    
    
    // MARK: - Exposed methods
    
    init(currentPage: Int, totalPageCount: Int) {
        update(currentPage: currentPage, totalPageCount: totalPageCount)
    }
    
    func update(currentPage: Int, totalPageCount: Int) {
        self.currentPage = currentPage
        self.totalPageCount = totalPageCount
    }
}
