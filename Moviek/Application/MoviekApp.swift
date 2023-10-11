
import SwiftUI

@main
struct MoviekApp: App {

//    init() {
//        UserDefaults.standard.removeObject(forKey: "recentsMoviesQueries")
//    }
    
    var body: some Scene {
        WindowGroup {
            let appFlowCoordinator = AppFlowCoordinator()
            appFlowCoordinator.start()
        }
    }
}
