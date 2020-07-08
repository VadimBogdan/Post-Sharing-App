//
//  Post + SectionModelType.swift
//  post sharing social media
//
//  Created by Вадим on 27.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import Model
import RxDataSources

struct PostSection {
    var sectionNumber: Int
    var items: [Item]
    
    public init(sectionNumber: Int, items: [Item]) {
        self.sectionNumber = sectionNumber
        self.items = items
    }
}

extension PostSection: AnimatableSectionModelType {
    typealias Item = Post
    
    init(original: PostSection, items: [Item]) {
        self = original
        self.items = items
    }
}

extension PostSection: IdentifiableType {
    typealias Identity = Int
    
    var identity: Int {
        return sectionNumber
    }
}

extension PostSection: Equatable {
    
    static func == (lhs: PostSection, rhs: PostSection) -> Bool {
        return lhs.sectionNumber == rhs.sectionNumber
            && lhs.items == rhs.items
    }
}
