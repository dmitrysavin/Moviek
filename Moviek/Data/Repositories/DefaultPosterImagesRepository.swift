
import Foundation

final class DefaultPosterImagesRepository {
    
    var imagesBasePath: String
    
    init(imagesBasePath: String) {
        self.imagesBasePath = imagesBasePath
    }
}

extension DefaultPosterImagesRepository: PosterImagesRepository {
    
    func posterUrl(withImagePath imagePath: String, width: Int) -> URL? {
        let closestWidth = calculateClosestWidth(for: CGFloat(width))
        let path = "/t/p/w\(closestWidth)\(imagePath)"
        let posterUrl = URL(string: imagesBasePath + path)
        return posterUrl
    }
    
    private func calculateClosestWidth(for width: CGFloat) -> Int {
        let sizes = [92, 154, 185, 342, 500, 780]
        return sizes
            .enumerated()
            .min { abs(CGFloat($0.1) - width) < abs(CGFloat($1.1) - width) }?
            .element ?? sizes.first!
    }
}
