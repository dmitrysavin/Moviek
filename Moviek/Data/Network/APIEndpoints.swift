
import Foundation

struct APIEndpoints {
    
    static func getMovies(with requestDTO: MoviesRequestDTO) -> Endpoint<MoviesResponseDTO> {
        return Endpoint(
            path: "3/search/movie",
            method: .get,
            queryParametersEncodable: requestDTO
        )
    }
}
