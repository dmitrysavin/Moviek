
import Foundation
import SwiftData

@Model
class MovieQueryEntity {
    @Attribute(.unique) var id: UUID = UUID()
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
