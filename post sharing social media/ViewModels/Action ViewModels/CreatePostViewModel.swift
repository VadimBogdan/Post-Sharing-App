//
//  CreatePostViewModel.swift
//  post sharing social media
//
//  Created by Вадим on 28.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import CoreDataRepository
import Model
import RxSwift
import RxCocoa

class CreatePostViewModel: ViewModelType {
    
    struct Input {
        let cancelTrigger: Driver<Void>
        let confirmTrigger: Driver<Void>
        let body: Driver<String>
        let title: Driver<String>
    }
    
    struct Output {
        let canConfirm: Driver<Bool>
        let saveTrigger: Driver<Void>
        let dismiss: Driver<Void>
    }
    
    var input: CreatePostViewModel.Input
    var output: CreatePostViewModel.Output
    
    typealias ViewModelBuilder = (CreatePostViewModel.Input) ->
        CreatePostViewModel
    
    init(input: CreatePostViewModel.Input, postsRepository: AnyRepository<Post>) {
        self.input = input
        self.output = CreatePostViewModel.transform(input: input, postsRepository: postsRepository)
        self.process(postsRepository: postsRepository)
    }
    
    func process(postsRepository: AnyRepository<Post>) {

        
        //input.confirmTrigger
    }
}

extension CreatePostViewModel {
    
    static func transform(input: CreatePostViewModel.Input, postsRepository: AnyRepository<Post>) -> CreatePostViewModel.Output {
        
        let titleAndBody = Driver.combineLatest(input.title, input.body)
        
        let canConfirm = titleAndBody.flatMapLatest { Driver.just(!$0.0.isEmpty && !$0.1.isEmpty) }
        
        let saveTrigger = input.confirmTrigger.withLatestFrom(titleAndBody)
            .map {
                print("\(Int(Date().timeIntervalSince1970))", Date().description)
                let timestamp = Int(Date().timeIntervalSince1970)
                let uuid = UUID().uuidString
                return Post(body: $0.1, title: $0.0, uuid: uuid, userId: "test_user", createdAt: "\(timestamp)" )
            }
            .flatMapLatest {
                return postsRepository.save(entity: $0)
                .asDriver(onErrorJustReturn: ())
            }
        
        let dismiss = Driver.of(saveTrigger, input.cancelTrigger).debug("of")
            .merge().debug("merge")
        
        return Output(canConfirm: canConfirm, saveTrigger: saveTrigger, dismiss: dismiss)
    }
}
