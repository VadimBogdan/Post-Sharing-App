//
//  CDPost+Ext.swift
//  CoreDataRepository
//
//  Created by Вадим on 05.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import Model
import QueryKit

extension CDPost {
    public static var userId: Attribute<String> { return Attribute("userId") }
    public static var createdAt: Attribute<String> { return Attribute("createdAt") }
}

extension CDPost: Persistable {
    
    public static var entityName: String {
        return "CDPost"
    }
    
    public func predicate() -> NSPredicate {
        return CDPost.primaryAttribute == uuid
    }
}

extension CDPost: ModelConvertibleType {
    
    public func asModel() -> Post {
        return Post(body: body!,
                    title: title!,
                    uuid: uuid!,
                    userId: userId!,
                    createdAt: createdAt!)
    }
}

extension Post: CoreDataRepresentable {
    
    public typealias CoreDataType = CDPost
    
    public func update(_ entity: CDPost) {
        entity.body = body
        entity.title = title
        entity.uuid = uuid
        entity.userId = userId
        entity.createdAt = createdAt
    }
    
}
