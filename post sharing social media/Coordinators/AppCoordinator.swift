//
//  AppCoordinator.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    private(set) weak var window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let navController = AppUINavigationController()
        let router = AppRouter(navigationController: navController)
        
        let hallCoordinator = HallCoordinator(router: router)
        hallCoordinator.start()
        
        self.add(hallCoordinator)
        
        LaunchScreenManager.instance.animateAfterLaunch(navController.view)
        
        // show on screen
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
