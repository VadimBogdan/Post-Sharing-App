//
//  CoreDataStack.swift
//  CoreDataRepository
//
//  Created by Вадим on 04.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataStack {
    
    static let modelName = "PostAppModel"
    
    public let backgroundContext: NSManagedObjectContext
    
    fileprivate let persistentContainer: NSPersistentContainer
    
    public init() {
        persistentContainer = NSPersistentContainer(name: CoreDataStack.modelName)
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        backgroundContext = persistentContainer.newBackgroundContext()
    }
}
