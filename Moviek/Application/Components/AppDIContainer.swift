
import Foundation

final class AppDIContainer {
    
    // MARK: - Network
    static let networkManager: NetworkManager = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: AppConfiguration.apiBaseURL)!,
            queryParameters: [
                "api_key": AppConfiguration.apiKey,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )

        return DefaultNetworkManager.init(config: config)
    }()
}
