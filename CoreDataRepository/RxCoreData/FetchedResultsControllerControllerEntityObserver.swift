//
//  FetchedResultsControllerControllerEntityObserver.swift
//  CoreDataRepository
//
//  Created by Вадим on 01.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

final class FetchedResultsControllerEntityObserver<T: NSFetchRequestResult> : NSObject, NSFetchedResultsControllerDelegate {
    
    typealias Observer = AnyObserver<[T]>
    
    private let observer: Observer
    private let frc: NSFetchedResultsController<T>
    
    
    init(observer: Observer, fetchRequest: NSFetchRequest<T>, managedObjectContext context: NSManagedObjectContext, sectionNameKeyPath: String?, cacheName: String?) {
        self.observer = observer
        

        self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
        super.init()
        
        context.perform {
            self.frc.delegate = self
            
            do {
                try self.frc.performFetch()
            } catch let e {
                observer.on(.error(e))
            }
            
            self.sendNextElement()
        }
    }
    
    private func sendNextElement() {
        self.frc.managedObjectContext.perform {
            let entities = self.frc.fetchedObjects ?? []
            self.observer.on(.next(entities))
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendNextElement()
    }
    /// Delegate implementation for `Disposable`
    /// required methods - This is kept in here
    /// to make `frc` private.
    public func dispose() {
        frc.delegate = nil
    }
}

extension FetchedResultsControllerEntityObserver : Disposable { }
