
import Foundation

final class MovieCellVM: ObservableObject {
    
    @Published var posterURL: URL?
    
    let title: String
    let posterImagePath: String?
    let releaseDate: String?
    let imageSize: CGSize = CGSize(width: 92.0, height: 138.0)
    
    private let posterImagesRepository: PosterImagesRepository
    
    
    init(
        movie: Movie,
        posterImagesRepository: PosterImagesRepository
    ) {
        self.title = movie.title ?? ""
        self.posterImagePath = movie.posterPath

        if let releaseDate = movie.releaseDate {
            self.releaseDate = displayDateFormatter.string(from: releaseDate)
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
