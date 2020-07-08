//
//  CDPost+CoreDataProperties.swift
//  CoreDataRepository
//
//  Created by Вадим on 05.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//
//

import Foundation
import CoreData


extension CDPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPost> {
        return NSFetchRequest<CDPost>(entityName: "CDPost")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var title: String?
    @NSManaged public var userId: String?
    @NSManaged public var uuid: String?

}
