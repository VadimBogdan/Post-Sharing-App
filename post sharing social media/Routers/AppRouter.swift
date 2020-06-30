//
//  AppRouter.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit

class AppRouter: NSObject, Router {
    
    let navigationController: UINavigationController
    
    private var closures: [String: NavigationBackAction] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }
    
    func push(_ drawable: Drawable, animated: Bool, OnNavigateBack closure: NavigationBackAction?) {
        guard let viewController = drawable.viewController else { return }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        #if DEBUG
        print(viewController.description)
        #endif
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss closure: NavigationBackAction?) {
        
        guard let viewController = drawable.viewController else { return }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.present(viewController, animated: true, completion: closure)
        viewController.presentationController?.delegate = self
    }
    
    func pop(_ animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func popToRoot(_ animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else {
            return
        }
        closure()
    }
    
}

extension AppRouter: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        executeClosure(presentationController.presentedViewController)
    }
}

extension AppRouter: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let previousVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousVC) else {
            return
        }
                
        executeClosure(previousVC)
    }
}
