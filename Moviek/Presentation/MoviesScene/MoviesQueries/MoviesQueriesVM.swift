
import Foundation

protocol MoviesQueriesVMInput {
    func updateMoviesQueries() async
}

protocol MoviesQueriesVMOutput {
    var items: [String] { get }
}

protocol MoviesQueriesVM: MoviesQueriesVMInput & MoviesQueriesVMOutput & ObservableObject {
}


final class DefaultMoviesQueriesVM: MoviesQueriesVM {
    
    // MARK: - Exposed properties
    @Published var items: [String] = []
    
    
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
        do {
            let movieQueries = try await moviesQueriesUseCase.execute(maxCount: numberOfQueriesToShow)
            items = movieQueries
                .map { $0.query }
        } catch {}
    }
}
