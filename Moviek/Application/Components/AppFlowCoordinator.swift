
import SwiftUI

final class AppFlowCoordinator {

    func start() -> some View {
        // In App Flow we can check if user needs to login, if yes we can show login screen
                
        let moviesSceneBuilder = MoviesSceneBuilder()
        let screen = moviesSceneBuilder.makeMoviesSearchScreen()
        return screen
    }
}
