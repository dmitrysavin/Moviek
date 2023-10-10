
import Foundation

protocol MovieDetailsVMOutput {
    var posterURL: URL? { get }
    var imageWidth: Int { get }
    
    var title: String { get }
    var overview: String { get }
    var posterImagePath: String? { get }
    var releaseDate: String? { get }
}

protocol MovieDetailsVM: MovieDetailsVMOutput & ObservableObject {
}

final class DefaultMovieDetailsVM: MovieDetailsVM {
    
    // MARK: - Exposed properties

    @Published var posterURL: URL?
    
    var title: String
    var posterImagePath: String?
    var releaseDate: String?
    var overview: String
    var imageWidth: Int = 154
    
    
    // MARK: - Private properties
    
    private let imagePathResolver: ImagePathResolver
    
    
    // MARK: - Exposed methods
    
    init(
        movie: Movie,
        imagePathResolver: ImagePathResolver = ImagePathResolver()
    ) {
        self.title = movie.title ?? ""
        self.posterImagePath = movie.posterPath ?? ""
        self.overview = movie.overview ?? ""

        if let releaseDate = movie.releaseDate {
            self.releaseDate = DateFormatter.displayFormatter.string(from: releaseDate)
        } else {
            self.releaseDate = nil
        }
        
        self.imagePathResolver = imagePathResolver
        updatePosterURL()
    }
    
    
    // MARK: - Private methods
    
    func updatePosterURL() {
        guard let imagePath = self.posterImagePath else { return }
        
        self.posterURL = imagePathResolver.imageUrl(
            withImagePath: imagePath,
            width: Int(imageWidth)
        )
    }
}
