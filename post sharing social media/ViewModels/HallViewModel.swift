//
//  HallViewModel.swift
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
    
    init(input: HallViewModel.Input, postsRepository: AnyRepository<Post>) {
        self.input = input
        self.output = HallViewModel.transform(postsRepository: postsRepository)
        self.process()
    }
    
    func process() {
        
    }
    
}

private extension HallViewModel {
    static func transform(postsRepository: AnyRepository<Post>) -> Output {
        let post = Post(body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", title: "TITLE", uuid: "", userId: "", createdAt: "124435652")
        let postSection = PostSection(sectionNumber: 0, items: [post])
        
        let posts = postsRepository.query(with: nil, sortDescriptors: [CDPost.userId.ascending(), CDPost.createdAt.descending()], sectionNameKeyPath: "userId")
            .map { return [PostSection(sectionNumber: 0, items: $0)] }
        
        return Output(posts: posts.map {
            $0[0].items.count == 0 ? [postSection] : $0 }
                .asDriver(onErrorJustReturn: [postSection])
        )
        
        
        //Output(posts: Observable.just([postSection]).asDriver(onErrorJustReturn: []))
    }
}
