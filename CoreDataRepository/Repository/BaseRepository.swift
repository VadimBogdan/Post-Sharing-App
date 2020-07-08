//
//  PostAppRepository.swift
//  CoreDataRepository
//
//  Created by Вадим on 30.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

public class BaseRepository<T: CoreDataRepresentable>: Repository where T == T.CoreDataType.ModelType {
    
    fileprivate let context: NSManagedObjectContext
    fileprivate let scheduler: ContextScheduler
    
    public init(context: NSManagedObjectContext) {
        self.context = context
        self.scheduler = ContextScheduler(context: context)
    }
    
    public func query(with predicate: NSPredicate?,
                      sortDescriptors: [NSSortDescriptor]?,
                      sectionNameKeyPath: String?,
                      cacheName: String? = nil) -> Observable<[T]> {
        
        let request = T.CoreDataType.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        
        if let sectionNameKeyPath = sectionNameKeyPath {
            return context.rx.sections(fetchRequest: request,
                                       sectionNameKeyPath: sectionNameKeyPath,
                                       cacheName: cacheName)
                .map { $0.first }
                .map { $0 == nil ? [] : $0?.objects as! [T.CoreDataType] }
                .mapToModel()
                .subscribeOn(scheduler)
            
        } else {
            return context.rx.entities(fetchRequest: request)
                .mapToModel()
                .subscribeOn(scheduler)
        }

    }
    
    public func save(entity: T) -> Observable<Void> {
        /// - TODO: Add map to void
        return entity.sync(in: context)
            .map(entity.update)
            .flatMapLatest(context.rx.save)
            .subscribeOn(scheduler)
    }
    
    public func delete(entity: T) -> Observable<Void> {
        return entity.sync(in: context)
            .map { $0 as! NSManagedObject }
            .flatMapLatest(context.rx.delete)
            .subscribeOn(scheduler)
    }
}
