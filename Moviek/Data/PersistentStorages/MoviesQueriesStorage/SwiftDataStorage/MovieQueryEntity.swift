
import Foundation
import SwiftData

@Model
class MovieQueryEntity {
    let query: String

    init(query: String) {
        self.query = query
    }
}

extension MovieQueryEntity {
    func toDomain() -> MovieQuery {
        return .init(query: query)
    }
}
