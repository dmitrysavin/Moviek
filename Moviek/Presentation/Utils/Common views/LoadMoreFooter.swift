
import SwiftUI

struct LoadMoreFooter: View {
    
    var body: some View {
        HStack(spacing: 20)  {
            Spacer()
            Text("🎬")
                .font(.system(size: 20))
            Text("Getting the movies ...")
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(height: 44) // Approximate cell height
    }
}

struct LoadMoreFooter_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
