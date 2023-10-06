//
//  MoviekApp.swift
//  Moviek
//
//  Created by Dmytro Savin on 26.09.2023.
//

import SwiftUI

@main
struct MoviekApp: App {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?

    init() {
        appFlowCoordinator = AppFlowCoordinator(appDIContainer: appDIContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            appFlowCoordinator?.start()
        }
    }
}
