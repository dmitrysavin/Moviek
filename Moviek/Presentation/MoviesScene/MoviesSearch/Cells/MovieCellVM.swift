
import Foundation

final class MovieCellVM: ObservableObject {
    
    // MARK: - Exposed properties
    @Published var posterURL: URL?
    let title: String
    let posterImagePath: String?
    let releaseDate: String?
    let imageWidth: Int = 92
    
    
    // MARK: - Private properties
    private let imagePathResolver: ImagePathResolver
    
    
    // MARK: - Exposed methods
    init(
        movie: Movie,
        imagePathResolver: ImagePathResolver = ImagePathResolver()
    ) {
        self.title = movie.title ?? ""
        self.posterImagePath = movie.posterPath

        if let releaseDate = movie.releaseDate {
            self.releaseDate = DateFormatter.displayFormatter.string(from: releaseDate)
        } else {
            self.releaseDate = nil
        }
        
        self.imagePathResolver = imagePathResolver
        updatePosterURL()
    }
    
    func updatePosterURL() {
        guard let imagePath = self.posterImagePath else { return }
        
        self.posterURL = imagePathResolver.imageUrl(
            withImagePath: imagePath,
            width: imageWidth
        )
    }    
}


extension MovieCellVM: Equatable {
    static func == (lhs: MovieCellVM, rhs: MovieCellVM) -> Bool {
        return lhs.title == rhs.title &&
        lhs.posterImagePath == rhs.posterImagePath &&
        lhs.releaseDate == rhs.releaseDate
    }
}
