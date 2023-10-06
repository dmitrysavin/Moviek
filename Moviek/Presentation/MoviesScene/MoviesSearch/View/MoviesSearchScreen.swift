
import SwiftUI

struct MoviesSearchScreen<VM: MoviesSearchVM>: View {
    
    @ObservedObject private var viewModel: VM
    @State private var showAlert = false
    @State private var searchText: String = ""
  
    @ObservedObject private var keyboardCoordinator = KeyboardCoordinator()
    
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        var vm = viewModel // Capture a mutable reference
        let moviesQueriesVM = viewModel.moviesQueriesVM
        
        NavigationView {
            VStack {
                if keyboardCoordinator.isKeyboardVisible &&
                    moviesQueriesVM.items.count > 0 &&
                    searchText.isEmpty &&
                    viewModel.loadingState == .none {
                    
                    MoviesQueriesView(viewModel: moviesQueriesVM) { selectedQueryVM in
                        searchText = selectedQueryVM.query
                        viewModel.didSearch(text: searchText)
                    }
                } else {
                    MoviesSearchResultView(viewModel: viewModel)
                }
            }
            .navigationTitle("Movie Search")
            .searchable(text: $searchText)
            .onChange(of: viewModel.showAlert) { newValue in
                if newValue {
                    showAlert = true
                }
            }
            .onSubmit(of: .search) {
                viewModel.didSearch(text: searchText)
            }
            .onChange(of: searchText) { newText in
                if newText.isEmpty {
                    viewModel.didCancelSearch()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.errorMessage),
                      dismissButton: .default(Text("OK")) {
                        vm.showAlert = false
                        showAlert = false
                      })
            }
            .onAppear() {
                moviesQueriesVM.updateMoviesQueries()
            }
        }
    }
}
