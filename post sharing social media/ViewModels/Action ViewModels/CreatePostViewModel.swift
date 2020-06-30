//
//  CreatePostViewModel.swift
//  post sharing social media
//
//  Created by Вадим on 28.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CreatePostViewModel: ViewModelType {
    
    struct Input {
        let cancelTrigger: Driver<Void>
        let confirmTrigger: Driver<Void>
    }
    
    struct Output {
        
    }
    
    var input: CreatePostViewModel.Input
    var output: CreatePostViewModel.Output
    
    typealias ViewModelBuilder = (CreatePostViewModel.Input) ->
        CreatePostViewModel
    
    init(input: CreatePostViewModel.Input) {
        self.input = input
        self.output = CreatePostViewModel.transform(input: input)
    }
}

extension CreatePostViewModel {
    
    static func transform(input: CreatePostViewModel.Input) -> CreatePostViewModel.Output {
        
        return Output()
    }
}
