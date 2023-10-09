
import Foundation
import UIKit
import Combine

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
    
    @Published var posterURL: URL?
    
    var title: String
    var posterImagePath: String?
    var releaseDate: String?
    var overview: String
    
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType = DispatchQueue.main
    
    private let posterImagesRepository: PosterImagesRepository

    var imageWidth: Int = 154 {
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
        self.posterImagePath = movie.posterPath ?? ""
        self.overview = movie.overview ?? ""

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
            width: imageWidth
        )
    }
}
