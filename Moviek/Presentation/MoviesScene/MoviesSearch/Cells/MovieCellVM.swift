
import Foundation

final class MovieCellVM: ObservableObject {
    
    // MARK: - Exposed properties
    
    @Published var posterURL: URL?
    
    let title: String
    let posterImagePath: String?
    let releaseDate: String?
    let imageSize: CGSize = CGSize(width: 92.0, height: 138.0)
    
    
    // MARK: - Private properties
    
    private let posterImagesRepository: PosterImagesRepository
    
    
    // MARK: - Exposed methods
    
    init(
        movie: Movie,
        posterImagesRepository: PosterImagesRepository
    ) {
        self.title = movie.title ?? ""
        self.posterImagePath = movie.posterPath

        if let releaseDate = movie.releaseDate {
            self.releaseDate = DateFormatter.displayFormatter.string(from: releaseDate)
        } else {
            self.releaseDate = nil
        }
        
        self.posterImagesRepository = posterImagesRepository
        updatePosterURL()
    }
    
    func updatePosterURL() {
        guard let imagePath = self.posterImagePath else { return }
        
        self.posterURL = posterImagesRepository.posterUrl(
            withImagePath: imagePath,
            width: Int(imageSize.width)
        )
    }    
}
