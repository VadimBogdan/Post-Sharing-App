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

public protocol Persistable: NSFetchRequestResult & ModelConvertibleType {
    
    static var entityName: String { get }
    
    /// The attribute name to be used to uniquely identify each instance.
    static var primaryAttribute: Attribute<String> { get }
    
    static func fetchRequest() -> NSFetchRequest<Self>
}

extension Persistable {

    public static var primaryAttribute: Attribute<String> {
        return Attribute("uuid")
    }
}
