
import SwiftUI
import Kingfisher

struct MovieСell: View {
    
    // MARK: - Private properties
    
    @ObservedObject private var viewModel: MovieCellVM
    
    
    // MARK: - Exposed methods
    
    init(viewModel: MovieCellVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.title)
                    .font(.system(size: 20))
                    .bold()
                
                if let releaseDate = viewModel.releaseDate {
                    Text(releaseDate)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            KFImage(viewModel.posterURL)
                .cancelOnDisappear(true)
                .resizable()
                .placeholder {
                    Rectangle().fill(Color.gray)
                }
                .frame(width: CGFloat(viewModel.imageWidth),
                       height: CGFloat(viewModel.imageWidth) * 1.5)
        }
    }
}
