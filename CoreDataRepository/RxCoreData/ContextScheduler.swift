//
//  ContextScheduler.swift
//  CoreDataRepository
//
//  Created by Вадим on 04.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

final class ContextScheduler: ImmediateSchedulerType {
    
    fileprivate let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        
        let disposable = SingleAssignmentDisposable()
        
        context.perform {
            if disposable.isDisposed {
                return
            }
            disposable.setDisposable(action(state))
        }
        
        return disposable
    }
}
