
import Foundation

protocol MoviesRepository {
    
    func fetchMovies(
        searchText: String,
        page: Int) async throws -> MoviesPage
}
