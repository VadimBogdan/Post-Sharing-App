//
//  BaseCoordinator.swift
//  post sharing social media
//
//  Created by Вадим on 25.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation

/// Abstract base class for coordinators
class BaseCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    
    var isCompleted: (() -> Void)?
    
    func start() {
        fatalError("BaseCoordinator.start() -> Method MUST BE overridden in subclasses")
    }
}
