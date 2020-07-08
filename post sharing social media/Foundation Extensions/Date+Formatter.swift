//
//  Date+Formatter.swift
//  post sharing social media
//
//  Created by Вадим on 07.07.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation

extension Date {
    
    func toLocalized(format: String = "MMM dd, yyyy | h:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        //formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter.string(from: self)
    }
}
