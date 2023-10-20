
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
    
    
    // MARK: - Exposed methods
    init(searchMoviesUseCase: MoviesQueriesUseCase) {
        self.moviesQueriesUseCase = searchMoviesUseCase
    }
    
    @MainActor func updateMoviesQueries() {
        let requestValue = MoviesQueriesUseCaseRequestValue(maxCount: 10)

        Task {
            do {
                let movieQueries = try await moviesQueriesUseCase.execute(requestValue: requestValue)
                items = movieQueries
                    .map { $0.query }
                    .map(MoviesQueryCellVM.init)
            }
        }
    }
}

