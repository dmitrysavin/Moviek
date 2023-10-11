
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
    private let searchMoviesUseCase: MoviesQueriesUseCase
    private let mainQueue: DispatchQueueType
    private var queriesLoadTask: Cancellable? { willSet { queriesLoadTask?.cancel() } }
    
    
    // MARK: - Exposed methods
    init(
        searchMoviesUseCase: MoviesQueriesUseCase,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.searchMoviesUseCase = searchMoviesUseCase
        self.mainQueue = mainQueue
    }
    
    func updateMoviesQueries() {
        let requestValue = MoviesQueriesUseCaseRequestValue(maxCount: 10)

        queriesLoadTask = searchMoviesUseCase.execute(
            requestValue: requestValue,
            completion: { [weak self] result in

                self?.mainQueue.async {
                    switch result {
                    case .success(let items):
                        self?.items = items
                            .map { $0.query }
                            .map(MoviesQueryCellVM.init)
                    case .failure:
                        break
                    }
                }
        })
    }
}
