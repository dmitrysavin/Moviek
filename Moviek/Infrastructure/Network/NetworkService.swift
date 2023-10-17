
import Foundation

protocol NetworkService {
    func executeRequest<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T
}

struct DefaultNetworkService: NetworkService {

    private let config: NetworkConfigurable

    init(config: NetworkConfigurable) {
        self.config = config
    }

    func executeRequest<T: Decodable>(_ endpoint: Endpoint<T>) async throws -> T {
        let request = try endpoint.urlRequest(with: config)
        let (data, _) = try await URLSession.shared.data(for: request)
        let responseDTO: T = try endpoint.responseDecoder.decode(data)
        return responseDTO
    }
}
