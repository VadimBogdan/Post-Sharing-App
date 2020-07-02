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

protocol ModelConvertibleType {
    associatedtype ModelType
    
    func asModel() -> ModelType
}

protocol CoreDataRepresentable {
    associatedtype CoreDataType: Persistable
    
    var uid: String { get }
    
    init(entity: CoreDataType)
    
    func update(_ entity: CoreDataType)
}

extension CoreDataRepresentable {
//    func sync(in context: NSManagedObjectContext) -> Observable<CoreDataType> {
//        /**
//            I am currently stopped here
//            implementation will change
//        */
//        // return context.rx
//    }
}
