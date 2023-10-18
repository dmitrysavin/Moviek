
import Foundation

protocol MoviesQueriesVMInput {
    func updateMoviesQueries()
}

protocol MoviesQueriesVMOutput {
    var items: [MoviesQueryCellVM] { get }
}

protocol MoviesQueriesVM: MoviesQueriesVMInput & MoviesQueriesVMOutput & ObservableObject {
}

final class DefaultMoviesQueriesVM: MoviesQueriesVM {
    
    // MARK: - Exposed properties
    @Published var items: [MoviesQueryCellVM] = []
    
    
    // MARK: - Private properties
    private let moviesQueriesUseCase: MoviesQueriesUseCase
    private let mainQueue: DispatchQueueType
    private var queriesLoadTask: Cancellable? { willSet { queriesLoadTask?.cancel() } }
    
    
    // MARK: - Exposed methods
    init(
        searchMoviesUseCase: MoviesQueriesUseCase,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.moviesQueriesUseCase = searchMoviesUseCase
        self.mainQueue = mainQueue
    }
    
    func updateMoviesQueries() {
        let requestValue = MoviesQueriesUseCaseRequestValue(maxCount: 10)

        Task {
            do {
                let movieQueries = try await moviesQueriesUseCase.execute(requestValue: requestValue)
                DispatchQueue.main.async { [weak self] in
                    self?.items = movieQueries
                        .map { $0.query }
                        .map(MoviesQueryCellVM.init)
                }
            }
        }
    }
}
