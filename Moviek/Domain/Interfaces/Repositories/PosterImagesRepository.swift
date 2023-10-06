
import Foundation

protocol PosterImagesRepository {
    var imagesBasePath: String { get }

    func posterUrl(withImagePath imagePath: String, width: Int) -> URL?
}
