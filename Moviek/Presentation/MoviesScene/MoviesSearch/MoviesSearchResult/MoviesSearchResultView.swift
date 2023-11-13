
import SwiftUI

struct MoviesSearchResultView: View {
    
    // MARK: - Exposed properties
    var loadNextPageClosure:  (() -> Void)? = nil

    
    // MARK: - Private properties
    private var viewModel: MoviesSearchResultVM
    private let sceneBuilder: MoviesSceneBuilder
    
    
    // MARK: - Exposed methods
    init(
        viewModel: MoviesSearchResultVM,
        sceneBuilder: MoviesSceneBuilder = MoviesSceneBuilder()
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
                            let movie = viewModel.movie(atIndex: index)
                            sceneBuilder.makeMovieDetailsScreen(movie: movie)
                        } label: {
                            let vm = viewModel.items[index]
                            MovieСell(viewModel: vm)
                                .onAppear() {
                                    if index == viewModel.items.count - 1 {
                                        loadNextPageClosure?()
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
