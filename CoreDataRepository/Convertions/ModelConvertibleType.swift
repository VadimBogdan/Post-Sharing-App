//
//  ModelConvertibleType.swift
//  CoreDataRepository
//
//  Created by Вадим on 30.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

public protocol ModelConvertibleType {
    associatedtype ModelType
    
    func asModel() -> ModelType
}

public protocol CoreDataRepresentable {
    associatedtype CoreDataType: Persistable
    
    var uuid: String { get }
    
    func update(_ entity: CoreDataType)
}

extension CoreDataRepresentable {
    func sync(in context: NSManagedObjectContext) -> Observable<CoreDataType> {
        return context.rx.sync(uuid: uuid)
    }
}
