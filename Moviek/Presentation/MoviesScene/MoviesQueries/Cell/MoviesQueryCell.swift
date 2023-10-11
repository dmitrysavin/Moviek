
import SwiftUI

struct MoviesQueryCell: View {

    // MARK: - Exposed properties
    var onTap: ((MoviesQueryCellVM) -> Void)? = nil

    
    // MARK: - Private properties
    private var viewModel: MoviesQueryCellVM
    
    
    // MARK: - Exposed methods
    init(viewModel: MoviesQueryCellVM, onTap: ((MoviesQueryCellVM) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onTap = onTap
    }

    var body: some View {
        Button(action: {
            onTap?(viewModel)
        }) {
            HStack {
                Text(viewModel.query)
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
