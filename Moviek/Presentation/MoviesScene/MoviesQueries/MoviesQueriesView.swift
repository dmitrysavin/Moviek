
import SwiftUI

struct MoviesQueriesView<VM: MoviesQueriesVM>: View {
    
    // MARK: - Private properties
    @ObservedObject private var viewModel: VM
    
    
    // MARK: - Exposed properties
    var onTap: ((MoviesQueryCellVM) -> Void)? = nil
    
    
    // MARK: - Exposed methods
    init(viewModel: VM, onTap: ((MoviesQueryCellVM) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTap = onTap
        Task {
            await viewModel.updateMoviesQueries()
        }
    }
    
    var body: some View {
        List {
            ForEach(viewModel.items.indices, id: \.self) { index in
                if index < viewModel.items.count {
                    let moviesQueryCellVM = viewModel.items[index]
                    MoviesQueryCell(viewModel: moviesQueryCellVM) { selectedQueryVM in
                        onTap?(selectedQueryVM)
                    }
                }
            }
        }
    }
}
