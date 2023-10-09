
import Combine
import SwiftUI

class KeyboardManager: ObservableObject {
    
    @Published var isKeyboardVisible: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        subscribeToKeyboardNotifications()
    }
    
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
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
