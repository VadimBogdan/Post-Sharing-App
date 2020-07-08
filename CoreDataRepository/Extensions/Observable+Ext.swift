//
//  Observable + Ext.swift
//  CoreDataRepository
//
//  Created by Вадим on 04.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: Sequence, Element.Iterator.Element: ModelConvertibleType {
    typealias ModelType = Element.Iterator.Element.ModelType
    
    func mapToModel() -> Observable<[ModelType]> {
        return map { sequence -> [ModelType] in
            return sequence.mapToModel()
        }
    }
}

extension Sequence where Iterator.Element: ModelConvertibleType {
    typealias Element = Iterator.Element
    
    func mapToModel() -> [Element.ModelType] {
        return map {
            return $0.asModel()
        }
    }
}
