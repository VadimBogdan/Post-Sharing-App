//
//  Post + IdentifiableType.swift
//  post sharing social media
//
//  Created by Вадим on 27.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import RxDataSources

extension Post: IdentifiableType {
    public typealias Identity = String
    
    public var identity: String {
        return uuid
    }
}
