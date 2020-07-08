//
//  HallCoordinator.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import Model
import CoreDataRepository
import RxSwift
import RxCocoa

class HallCoordinator: BaseCoordinator {
    
    let router: Router
    
    let postsRepository: AnyRepository<Post>
    
    let bag = DisposeBag()
    
    init(router: Router, postsRepository: AnyRepository<Post>) {
        self.router = router
        self.postsRepository = postsRepository
    }
    
    override func start() {
        let hallVC = HallViewController()
        
        hallVC.viewModelBuilder = { [bag, weak self, unowned postsRepository] input in
            let viewModel = HallViewModel(input: input, postsRepository: postsRepository)
            
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
        let createPostViewController = CreatePostViewController()
        createPostViewController.viewModelBuilder = { [bag, unowned createPostViewController, unowned postsRepository] input in
            
            let viewModel = CreatePostViewModel(input: input, postsRepository: postsRepository)
            
            viewModel.output.dismiss
                .do(onNext: {
                     createPostViewController.presentingViewController?.dismiss(animated: true)
                })
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(createPostViewController, animated: false)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        
        router.present(navigationController, isAnimated: true, onDismiss: nil)
    }
}
