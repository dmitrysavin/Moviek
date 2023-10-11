
import SwiftUI

struct MoviesSearchResultView<VM: MoviesSearchVM>: View {
    
    // MARK: - Private properties
    
    @ObservedObject private var viewModel: VM
    private let sceneBuilder: DefaultMoviesSceneBuilder
    
    
    // MARK: - Exposed methods
    
    init(
        viewModel: VM,
        sceneBuilder: DefaultMoviesSceneBuilder = DefaultMoviesSceneBuilder()
    ) {
        self.viewModel = viewModel
        self.sceneBuilder = sceneBuilder
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.items.indices, id: \.self) { index in
                    if index < viewModel.items.count { // Validate the index before accessing
                        NavigationLink {
                            viewModel.movieDetailsScreen(forMovieIndex: index,
                                                         builder: sceneBuilder)
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
            .listStyle(PlainListStyle())

            if viewModel.loadingState == .firstPage {
                LoadingView()
                    .edgesIgnoringSafeArea(.all)
            } else if viewModel.loadingState == .emptyPage {
                NoResultsView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
