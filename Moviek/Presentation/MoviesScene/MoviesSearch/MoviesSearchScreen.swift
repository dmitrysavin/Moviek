
import SwiftUI

struct MoviesSearchScreen<VM: MoviesSearchVM>: View {
    
    // MARK: - Private properties
    @ObservedObject private var viewModel: VM
    @ObservedObject private var keyboardManager = KeyboardHelper()
    @State private var showAlert = false // Needed to fix .alert(isPresented:) Xcode bug.
    @State private var searchText: String = ""
    private let sceneBuilder: MoviesSceneBuilder
    
    
    // MARK: - Exposed methods
    init(
        viewModel: VM,
        moviesSceneBuilder: MoviesSceneBuilder = MoviesSceneBuilder()
    ) {
        self.viewModel = viewModel
        self.sceneBuilder = moviesSceneBuilder
    }
    
    var body: some View {
        var vm = viewModel // Capture a mutable reference
        
        NavigationView {
            VStack {
                if keyboardManager.isKeyboardVisible &&
                    searchText.isEmpty &&
                    viewModel.loadingState == .none {

                    sceneBuilder.makeMoviesQueriesView { query in
                        searchText = query
                        Task {
                            await viewModel.didSearch(text: searchText)
                        }
                        hideKeyboard()
                    }
                } else {
                    MoviesSearchResultView(
                        viewModel: viewModel
                    )
                }
            }
            .navigationTitle(Text("find_your_movie"))
            .searchable(text: $searchText, prompt: Text("search..."))
            .disableAutocorrection(true)
            .onChange(of: viewModel.showAlert) { oldValue, newValue in
                if newValue {
                    showAlert = true
                }
            }
            .onSubmit(of: .search) {
                Task {
                    await viewModel.didSearch(text: searchText)
                }
            }
            .onChange(of: searchText) { oldValue, newValue in
                if oldValue.isEmpty == false && newValue.isEmpty {
                    Task {
                        await viewModel.didCancelSearch()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                let errorText = LocalizedStringKey(viewModel.errorMessage ?? "some_error")
                return Alert(title: Text("error"),
                      message: Text(errorText),
                      dismissButton: .default(Text("ok_all_capital")) {
                        vm.showAlert = false
                        vm.errorMessage = nil
                        showAlert = false
                      })
            }
        }
    }
}
