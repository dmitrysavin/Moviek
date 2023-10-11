
import Foundation

struct ImagePathResolver {
    
    // MARK: - Exposed properties
    let imagesBaseURL: String
    
    // MARK: - Exposed methods
    init(imagesBaseURL: String = AppConfiguration.imagesBaseURL) {
        self.imagesBaseURL = imagesBaseURL
    }
    
    func imageUrl(withImagePath path: String, width: Int) -> URL? {
        let closestWidth = closestImageWidth(for: CGFloat(width))
        let updatedPath = "/t/p/w\(closestWidth)\(path)"
        return URL(string: imagesBaseURL + updatedPath)
    }
    
    
    // MARK: - Private methods
    private func closestImageWidth(for width: CGFloat) -> Int {
        let sizes = [92, 154, 185, 342, 500, 780]
        return sizes
            .enumerated()
            .min { abs(CGFloat($0.1) - width) < abs(CGFloat($1.1) - width) }?
            .element ?? sizes.first!
    }
}
