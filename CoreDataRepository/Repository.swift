//
//  Repository.swift
//  CoreDataRepository
//
//  Created by Вадим on 30.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxSwift

protocol Repository {
    associatedtype Entity
    
    func query(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Observable<Entity>
    func save(entity: Entity) -> Observable<Void>
    func delete(entity: Entity) -> Observable<Void>
}
