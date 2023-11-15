
import SwiftUI

@main
struct MoviekApp: App {
    
    var body: some Scene {
        WindowGroup {
            let appFlowCoordinator = AppFlowCoordinator()
            appFlowCoordinator.start()
        }
    } 
}
