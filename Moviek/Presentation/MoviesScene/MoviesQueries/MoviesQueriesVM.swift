
import Foundation

protocol MoviesQueriesVMInput {
    func updateMoviesQueries() async
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
    private let numberOfQueriesToShow: Int
    
    
    // MARK: - Exposed methods
    init(
        searchMoviesUseCase: MoviesQueriesUseCase,
        numberOfQueriesToShow: Int = 10
    ) {
        self.moviesQueriesUseCase = searchMoviesUseCase
        self.numberOfQueriesToShow = numberOfQueriesToShow
    }
    
    @MainActor func updateMoviesQueries() async {
        let requestValue = MoviesQueriesUseCaseRequestValue(maxCount: numberOfQueriesToShow)

        do {
            let movieQueries = try await moviesQueriesUseCase.execute(requestValue: requestValue)
            items = movieQueries
                .map { $0.query }
                .map(MoviesQueryCellVM.init)
        } catch {}
    }
}
