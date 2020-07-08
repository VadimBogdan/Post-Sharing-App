//
//  Repository.swift
//  CoreDataRepository
//
//  Created by Вадим on 30.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxSwift

public protocol Repository {
    associatedtype Entity
    
    func query(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, sectionNameKeyPath: String?, cacheName: String?) -> Observable<[Entity]>
    func save(entity: Entity) -> Observable<Void>
    func delete(entity: Entity) -> Observable<Void>
}

/// Type-erased repository
public class AnyRepository<Entity: CoreDataRepresentable>: Repository where Entity == Entity.CoreDataType.ModelType {
    
    fileprivate let _query: (_ predicate: NSPredicate?, _ sortDescriptors: [NSSortDescriptor]?, _ sectionNameKeyPath: String?, _ cacheName: String?) -> Observable<[Entity]>
    
    fileprivate let _save: (_ entity: Entity) -> Observable<Void>
    
    fileprivate let _delete: (_ entity: Entity) -> Observable<Void>
    
    public init<R: Repository>(_ repository: R) where R.Entity == Entity {
        _query = repository.query
        _save = repository.save
        _delete = repository.delete
    }
    
    public func query(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, sectionNameKeyPath: String?, cacheName: String? = nil) -> Observable<[Entity]> {
        return _query(predicate, sortDescriptors, sectionNameKeyPath, cacheName)
    }
    
    public func save(entity: Entity) -> Observable<Void> {
        return _save(entity)
    }
    
    public func delete(entity: Entity) -> Observable<Void> {
        return _delete(entity)
    }
}
