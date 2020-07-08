//
//  NSManagedObjectContext + Rx.swift
//  CoreDataRepository
//
//  Created by Вадим on 01.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import CoreData
import QueryKit
import RxSwift

extension Reactive where Base: NSManagedObjectContext {
    
    /**
     Executes a fetch request and returns the fetched objects as an `Observable` array of `NSManagedObjects`.
     - parameter fetchRequest: an instance of `NSFetchRequest` to describe the search criteria used to retrieve data from a persistent store
     - parameter sectionNameKeyPath: the key path on the fetched objects used to determine the section they belong to; defaults to `nil`
     - parameter cacheName: the name of the file used to cache section information; defaults to `nil`
     - returns: An `Observable` array of `NSManagedObjects` objects that can be bound to a table view.
     */
    func entities<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
                                            sectionNameKeyPath: String? = nil,
                                            cacheName: String? = nil) -> Observable<[T]> {
        
        return Observable.create { observer in
            let observerAdapter = FetchedResultsControllerEntityObserver(observer: observer, fetchRequest: fetchRequest, managedObjectContext: self.base, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
            
            return Disposables.create {
                observerAdapter.dispose()
            }
        }
    }
    
    /**
     Executes a fetch request and returns the fetched section objects as an `Observable` array of `NSFetchedResultsSectionInfo`.
     - parameter fetchRequest: an instance of `NSFetchRequest` to describe the search criteria used to retrieve data from a persistent store
     - parameter sectionNameKeyPath: the key path on the fetched objects used to determine the section they belong to; defaults to `nil`
     - parameter cacheName: the name of the file used to cache section information; defaults to `nil`
     - returns: An `Observable` array of `NSFetchedResultsSectionInfo` objects that can be bound to a table view.
     */
    func sections<T: NSFetchRequestResult>(fetchRequest: NSFetchRequest<T>,
                                      sectionNameKeyPath: String? = nil,
                                      cacheName: String? = nil) -> Observable<[NSFetchedResultsSectionInfo]> {

        return Observable.create { observer in
            let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                 managedObjectContext: self.base,
                                                 sectionNameKeyPath: sectionNameKeyPath,
                                                 cacheName: cacheName)
            
            let observerAdapter = FetchedResultsControllerSectionObserver(observer: observer, frc: frc)
            return Disposables.create {
                observerAdapter.dispose()
            }
        }
    }
    
    /**
     Performs transactional update, initiated on a separate managed object context, and propagating thrown errors.
     - parameter updateAction: a throwing update action
     */
    func performUpdate(updateAction: (NSManagedObjectContext) throws -> Void) throws {
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = self.base
        
        try updateAction(privateContext)
        guard privateContext.hasChanges else { return }
        try privateContext.save()
        try self.base.save()
    }
}

extension Reactive where Base: NSManagedObjectContext {
    
    /**
     Creates, inserts, and returns a new `NSManagedObject` instance for the given `Persistable` concrete type (defaults to `Persistable`).
     */
    private func create<T: Persistable>(ofType: T.Type = T.self) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self.base) as! T
    }
    
    private func get<T: Persistable>(_ uuid: String?) throws -> T? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
        fetchRequest.predicate = T.primaryAttribute == uuid
        let result = (try self.base.execute(fetchRequest)) as! NSAsynchronousFetchResult<T>
        return result.finalResult?.first
    }
    
    /**
     Attempts to retrieve  remove a `NSManagedObject` object from a persistent store, and then attempts to commit that change or throws an error if unsuccessful.
     - seealso: `Persistable`
     - parameter persistable: a `Persistable` object
     */
    func delete<T: NSManagedObject>(_ entity: T) throws -> Observable<Void> {
        
        self.base.delete(entity)
        
        do {
            try entity.managedObjectContext?.save()
            return Observable.just(())
        } catch let e {
            return Observable.error(e)
        }
        
    }
    
    func save() -> Observable<Void> {
        return Observable.create { observer in
            do {
                try self.base.save()
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    /**
     Creates and executes a fetch request and returns the fetched objects as an `Observable` array of `Persistable`.
     - parameter type: the `Persistable` concrete type; defaults to `Persistable`
     - parameter format: the format string for the predicate; defaults to `""`
     - parameter arguments: the arguments to substitute into `format`, in the order provided; defaults to `nil`
     - parameter sortDescriptors: the sort descriptors for the fetch request; defaults to `nil`
     - returns: An `Observable` array of `Persistable` objects that can be bound to a table view.
     */
//    func entities<C: CoreDataRepresentable>(_ type: C.Type = C.self,
//                                  predicate: NSPredicate? = nil,
//                                  sortDescriptors: [NSSortDescriptor]? = nil) -> Observable<[C]> {
//        
//        let fetchRequest: NSFetchRequest<C.CoreDataType> = NSFetchRequest(entityName: C.CoreDataType.entityName)
//        fetchRequest.predicate = predicate
//        fetchRequest.sortDescriptors = sortDescriptors ?? [C.CoreDataType.primaryAttribute.ascending()]
//        
//        return entities(C.self, fetchRequest: fetchRequest).map { $0.map(C.init) }
//    }
    /**
     - parameter uuid: the unique entity's identifier if it has one
     */
    func sync<P>(uuid: String? = nil) -> Observable<P> where P: Persistable {
        do {
            let managedObject = try get(uuid) ?? create(ofType: P.self)
            return Observable.just(managedObject)
        } catch {
            return Observable.error(error)
        }
    }
    
}
