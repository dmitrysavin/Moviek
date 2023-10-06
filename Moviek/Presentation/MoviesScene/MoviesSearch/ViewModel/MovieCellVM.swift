
import Foundation
import UIKit
import Combine

final class MovieCellVM: ObservableObject {
    
    @Published var posterURL: URL?
    
    let title: String
    let posterImagePath: String?
    let releaseDate: String?
    
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType = DispatchQueue.main
    
    private let posterImagesRepository: PosterImagesRepository

    var imageWidth: Int = 100 {
        didSet {
            DispatchQueue.main.async { // This is to handle worning: Publishing changes from within view updates is not allowed, this will cause undefined behavior.
                self.updatePosterURL()
            }
        }
    }
    
    
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
            width: imageWidth
        )
    }    
}
