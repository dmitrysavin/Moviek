import Foundation

struct Movie: Equatable, Identifiable {
    typealias Identifier = String

    enum Genre {
        case adventure
        case scienceFiction
    }
    
    let id: Identifier
    let title: String?
    let genre: Genre?
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
}

struct MoviesPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}

extension Movie {
    static var mock: Movie {
        return Movie(
            id: "12345",
            title: "Star Wars",
            genre: .scienceFiction,
            posterPath: "/path/to/starwars.jpg",
            overview: "A long time ago in a galaxy far, far away...",
            releaseDate: Date(timeIntervalSince1970: 31536000) // Represents a date in 1971
        )
    }
}
