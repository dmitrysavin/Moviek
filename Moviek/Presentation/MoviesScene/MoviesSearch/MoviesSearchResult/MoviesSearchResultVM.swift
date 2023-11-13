
import Foundation

final class MoviesSearchResultVM {

    // MARK: - Exposed properties
    var items: [MovieCellVM] = []
    var loadingState: ViewModelLoadingState = .none

    
    // MARK: - Private properties
    var movies: [Movie] = []
    
    
    // MARK: - Exposed methods
    init(movies: [Movie], loadingState: ViewModelLoadingState) {
        self.movies = movies
        self.loadingState = loadingState
        
        self.items = movies.map {
            MovieCellVM(movie: $0)
        }
    }
    
    func movie(atIndex index: Int) -> Movie {
        movies[index]
    }
}
