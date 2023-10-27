
import SwiftUI

final class AppFlowCoordinator {

    func start() -> some View {
        // In App Flow we can check if user needs to login, if yes we can show login screen
        
        let moviesSceneBuilder = MoviesSceneBuilder()
        let screen = moviesSceneBuilder.makeMoviesSearchScreen()
        // For testing of localization.
//            .environment(\.locale, .init(identifier: "en"))
//            .environment(\.locale, .init(identifier: "zh-Hant"))
        return screen
    }
}
