
import SwiftUI

struct NoResultsView: View {
    
    var body: some View {
        VStack(spacing: 20)  {
            Text("🎥")
                .font(.system(size: 80))
            Text("No movies by your request. :(")
                .foregroundColor(.gray)
        }
    }
}

struct NoResultsView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
