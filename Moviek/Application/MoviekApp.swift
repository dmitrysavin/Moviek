
import SwiftUI

@main
struct MoviekApp: App {
    
    private let appDIContainer = AppDIContainer()
    private var appFlowCoordinator: AppFlowCoordinator // check 

    init() {
        appFlowCoordinator = AppFlowCoordinator(appDIContainer: appDIContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            appFlowCoordinator.start()
        }
    }
}
