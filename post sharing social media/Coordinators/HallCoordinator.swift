//
//  HallCoordinator.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HallCoordinator: BaseCoordinator {
    
    let router: Router
    
    let bag = DisposeBag()
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        let hallVC = HallViewController()
        
        hallVC.viewModelBuilder = { [bag, weak self] input in
            let viewModel = HallViewModel(input: input)
            
            input.triggerToCreatePost.map {
                self?.toCreatePost()
            }
            .drive()
            .disposed(by: bag)
            
            return viewModel
        }
        
        router.push(hallVC, animated: true, OnNavigateBack: isCompleted)
    }
}

extension HallCoordinator {
    
    func toCreatePost() {
        
    }
}
