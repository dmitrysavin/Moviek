
import SwiftUI
import Kingfisher

struct MovieСell: View {
    
    @ObservedObject private var viewModel: MovieCellVM
    
    private let imageWidth: Int = 92
    
    
    init(viewModel: MovieCellVM) {
        self.viewModel = viewModel
        self.viewModel.imageWidth = imageWidth
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
                .frame(width: CGFloat(imageWidth), height: 138)
        }
    }
}
