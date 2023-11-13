
import SwiftUI

struct MoviesQueryCell: View {

    // MARK: - Exposed properties
    var onTap: ((String) -> Void)? = nil

    
    // MARK: - Private properties
    private var query: String
    
    
    // MARK: - Exposed methods
    init(viewModel: String, onTap: ((String) -> Void)? = nil) {
        self.query = viewModel
        self.onTap = onTap
    }

    var body: some View {
        Button(action: {
            onTap?(query)
        }) {
            HStack {
                Text(query)
                    .foregroundColor(.blue)
                    .underline()
                Spacer() // Pushes the text to the leading edge
            }
            .contentShape(Rectangle()) // Makes the whole area tappable
        }
        .frame(maxWidth: .infinity) // This will make the button take the full width
        .buttonStyle(PlainButtonStyle()) // This is to remove the default button styles
    }
}
