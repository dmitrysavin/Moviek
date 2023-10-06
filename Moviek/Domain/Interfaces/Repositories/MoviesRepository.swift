
import Foundation

protocol MoviesRepository {
    @discardableResult
    func fetchMovies(
        searchText: String,
        page: Int,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable?
}
