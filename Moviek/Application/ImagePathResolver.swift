
import Foundation

struct ImagePathResolver {
    
    func imageUrl(withImagePath path: String, width: Int) -> URL? {
        let closestWidth = calculateClosestWidth(for: CGFloat(width))
        let path = "/t/p/w\(closestWidth)\(path)"
        let posterUrl = URL(string: AppConfiguration.imagesBaseURL + path)
        return posterUrl
    }
    
    
    // MARK: - Private methods
    
    private func calculateClosestWidth(for width: CGFloat) -> Int {
        let sizes = [92, 154, 185, 342, 500, 780]
        return sizes
            .enumerated()
            .min { abs(CGFloat($0.1) - width) < abs(CGFloat($1.1) - width) }?
            .element ?? sizes.first!
    }
}
