
import Foundation

final class DefaultMoviesRepository {
    
    // MARK: - Private properties
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue

    
    // MARK: - Exposed methods
    init(
        dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    
    // MARK: - Private methods
    func fetchMovies(
        searchText: String,
        page: Int,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> Cancellable? {
        
        let requestDTO = MoviesRequestDTO(query: searchText, page: page)
        let task = RepositoryTask()

            guard !task.isCancelled else { return nil }

            let endpoint = APIEndpoints.getMovies(with: requestDTO)
            task.networkTask = dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
        return task
    }
}
