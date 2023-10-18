
import Combine
import SwiftUI

class KeyboardHelper: ObservableObject {
    
    // MARK: - Exposed properties
    @Published var isKeyboardVisible: Bool = false
    
    
    // MARK: - Private properties
    private var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Exposed methods
    init() {
        subscribeToKeyboardNotifications()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    
    // MARK: - Private methods
    private func subscribeToKeyboardNotifications() {
    
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellables)
    }
}
