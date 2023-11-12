
import SwiftUI

struct MoviesQueriesView<VM: MoviesQueriesVM>: View {
    
    // MARK: - Private properties
    @ObservedObject private var viewModel: VM
    
    
    // MARK: - Exposed properties
    var onTap: ((String) -> Void)? = nil
    
    
    // MARK: - Exposed methods
    init(viewModel: VM, onTap: ((String) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTap = onTap
        Task {
            await viewModel.fetch()
        }
    }
    
    var body: some View {
        List {
            ForEach(viewModel.items.indices, id: \.self) { index in
                if index < viewModel.items.count {
                    let String = viewModel.items[index]
                    MoviesQueryCell(viewModel: String) { selectedQueryVM in
                        onTap?(selectedQueryVM)
                    }
                }
            }
        }
    }
}
