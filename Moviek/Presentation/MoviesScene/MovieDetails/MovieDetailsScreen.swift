
import SwiftUI
import Kingfisher

struct MovieDetailsScreen<VM: MovieDetailsVM>: View {

    // MARK: - Private properties
    private var viewModel: VM

    
    // MARK: - Exposed methods
    init(viewModel: VM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let posterURL = viewModel.posterURL {
                    KFImage(posterURL)
                        .cancelOnDisappear(true)
                        .resizable()
                        .placeholder {
                            Rectangle().fill(Color.gray)
                        }
                        .frame(width: CGFloat(viewModel.imageWidth), height: CGFloat(viewModel.imageWidth) * 1.5)
                        .padding(.top, 20) // padding from the top of the screen
                }

                Text(viewModel.title)
                    .font(.largeTitle)
                    .bold()
                
                if let releaseDate = viewModel.releaseDate {
                    Text("released: \(releaseDate)")
                        .font(.headline)
                }
                
                Text(viewModel.overview)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 10)
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
        }
        .accessibilityIdentifier(AccessibilityIdentifier.movieDetailsScreen)
    }
}
