//
//  HallViewModel.swift
//  post sharing social media
//
//  Created by Вадим on 26.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HallViewModel: ViewModelType {
    
    struct Input {
        let triggerToFetchPosts: Driver<Void>
        let triggerToCreatePost: Driver<Void>
    }
    
    struct Output {
        let posts: Driver<[PostSection]>
    }
    
    var input: HallViewModel.Input
    var output: HallViewModel.Output
    
    typealias ViewModelBuilder = (HallViewModel.Input) ->
        HallViewModel
    
    init(input: HallViewModel.Input) {
        self.input = input
        self.output = HallViewModel.transform(input: input)
    }
}

extension HallViewModel {
    static func transform(input: Input) -> Output {
        let post = Post(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", title: "TITLE", uuid: "", userId: "", creationDate: "CREATIONDATE")
        let postSection = PostSection(sectionNumber: 0, items: [post])
        return Output(posts: Observable.just([postSection]).asDriver(onErrorJustReturn: []))
    }
}
