
import Foundation

final class DefaultMoviesRepository {
    
    // MARK: - Private properties
    private let networkManager: NetworkService
    
    
    // MARK: - Exposed methods
    init(networkManager: NetworkService = AppDIContainer.networkManager) {
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
            let responseDTO = try await networkManager.executeRequest(endpoint)
            let moviesPage = responseDTO.toDomain()

            return moviesPage
        }
}
