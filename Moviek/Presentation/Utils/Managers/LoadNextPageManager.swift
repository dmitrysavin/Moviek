
import Foundation

class LoadNextPageManager {
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    
    var hasNextPage: Bool {
        currentPage < totalPageCount
    }
    
    var nextPage: Int {
        hasNextPage ? currentPage + 1 : currentPage
    }
    
    
    // Mark - Methods
    
    init(currentPage: Int, totalPageCount: Int) {
        update(currentPage: currentPage, totalPageCount: totalPageCount)
    }
    
    func update(currentPage: Int, totalPageCount: Int) {
        self.currentPage = currentPage
        self.totalPageCount = totalPageCount
    }
}
