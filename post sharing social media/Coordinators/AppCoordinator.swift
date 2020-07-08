//
//  AppCoordinator.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import CoreDataRepository
import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    private(set) weak var window: UIWindow!
    
    fileprivate var coreDataStack: CoreDataStack!
    
    init(window: UIWindow) {
        self.window = window
        self.coreDataStack = CoreDataStack()
    }
    
    override func start() {
        let navController = AppUINavigationController()
        let router = AppRouter(navigationController: navController)
        
        let postsRepository = PostsRepository(context: coreDataStack.backgroundContext)
        
        let hallCoordinator = HallCoordinator(router: router, postsRepository: AnyRepository(postsRepository))
        hallCoordinator.isCompleted = { [unowned self, unowned hallCoordinator] in
            self.remove(hallCoordinator)
        }
        self.add(hallCoordinator)

        hallCoordinator.start()

        LaunchScreenManager.instance.animateAfterLaunch(navController.view)

        // show on screen
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
}
