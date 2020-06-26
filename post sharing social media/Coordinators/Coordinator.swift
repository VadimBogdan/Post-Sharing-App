//
//  Coordinator.swift
//  post sharing social media
//
//  Created by Вадим on 25.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    
    var children: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func add(_ coordinator: Coordinator) {
        if !children.contains(where: { $0 === coordinator }) {
            children.append(coordinator)
        } else {
            print("BaseCoordinator.add() -> Attempt to add existing child")
        }
    }
    
    func remove(_ coordinator: Coordinator) {
        children = children.filter({ $0 !== coordinator })
    }
    
}
