//
//  Persistable.swift
//  CoreDataRepository
//
//  Created by Вадим on 30.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import CoreData
import QueryKit

protocol Persistable: NSFetchRequestResult {
    
    static var entityName: String { get }
    
    /// The attribute name to be used to uniquely identify each instance.
    static var primaryAttribute: Attribute<String> { get }
    
    /* predicate to uniquely identify the record, such as: NSPredicate(format: "code == '\(code)'") */
    static func predicate() -> NSPredicate
    
    // static func fetchRequest() -> NSFetchRequest<Self>
}

extension Persistable {

    static var primaryAttribute: Attribute<String> {
        return Attribute("uid")
    }
}
