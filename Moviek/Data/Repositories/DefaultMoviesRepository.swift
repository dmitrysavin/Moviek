
import Foundation

final class DefaultMoviesRepository {
    
    // MARK: - Private properties
    private let networkManager: NetworkManager
    
    
    // MARK: - Exposed methods
    init(networkManager: NetworkManager = AppDIContainer.networkManager) {
        self.networkManager = networkManager
    }
}


extension DefaultMoviesRepository: MoviesRepository {
    
    // MARK: - Exposed methods
    func fetchMovies(
        searchText: String,
        page: Int) async throws -> MoviesPage {
            
            let requestDTO = MoviesRequestDTO(query: searchText, page: page)
            let endpoint = APIEndpoints.getMovies(with: requestDTO)
            let responseDTO2 = try await networkManager.executeRequest(endpoint)
            let moviesPage = responseDTO2.toDomain()
        
            return moviesPage
        }
}
