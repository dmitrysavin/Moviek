
import SwiftUI

struct MoviesQueriesView<VM: MoviesQueriesVM>: View {
    
    @ObservedObject private var viewModel: VM
    var onTap: ((MoviesQueryCellVM) -> Void)? = nil
    
    init(viewModel: VM, onTap: ((MoviesQueryCellVM) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTap = onTap
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
//        .onAppear {
//            viewModel.updateMoviesQueries()
//        }
    }
}
