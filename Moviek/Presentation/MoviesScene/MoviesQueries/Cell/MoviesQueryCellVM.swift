
import Foundation

class MoviesQueryCellVM {
    
    // MARK: - Exposed properties
    
    let query: String

    
    // MARK: - Exposed methods
    
    init(query: String) {
        self.query = query
    }
}

extension MoviesQueryCellVM: Equatable {
    static func == (lhs: MoviesQueryCellVM, rhs: MoviesQueryCellVM) -> Bool {
        return lhs.query == rhs.query
    }
}
