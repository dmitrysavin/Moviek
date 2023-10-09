
import SwiftUI

final class AppFlowCoordinator {

    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }

    func start() -> some View {
        // In App Flow we can check if user needs to login, if yes we can show login screen
        
        let moviesSceneDIContainer = appDIContainer.makeMoviesSceneDIContainer()
        let screen = moviesSceneDIContainer.makeMoviesSearchScreen()
        return screen
    }
}
