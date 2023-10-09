
import Foundation

class MoviesQueryCellVM {
    let query: String

    init(query: String) {
        self.query = query
    }
}

extension MoviesQueryCellVM: Equatable {
    static func == (lhs: MoviesQueryCellVM, rhs: MoviesQueryCellVM) -> Bool {
        return lhs.query == rhs.query
    }
}
