
import SwiftUI

struct MoviesSearchResultView<VM: MoviesSearchVM>: View {
    
    @ObservedObject private var viewModel: VM
    
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.items.indices, id: \.self) { index in
                    if index < viewModel.items.count { // Validate the index before accessing
                        NavigationLink {
                            viewModel.didSelectItem(at: index)
                        } label: {
                            let vm = viewModel.items[index]
                            MovieСell(viewModel: vm)
                                .onAppear() {
                                    if index == viewModel.items.count - 1 {
                                        viewModel.didLoadNextPage()
                                    }
                                }
                        }
                    }
                }

                if viewModel.loadingState == .nextPage {
                    LoadMoreFooter()
                }
            }

            if viewModel.loadingState == .firstPage {
                LoadingView()
                    .edgesIgnoringSafeArea(.all)
            }
            
            if viewModel.loadingState == .emptyPage {
                NoResultsView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
