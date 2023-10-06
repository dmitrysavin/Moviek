
import Combine
import SwiftUI

class KeyboardCoordinator: ObservableObject {
    // Published property to track the visibility of the keyboard
    @Published var isKeyboardVisible: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        subscribeToKeyboardNotifications()
    }
    
    private func subscribeToKeyboardNotifications() {
        // When keyboard will show
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
        
        // When keyboard will hide
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
