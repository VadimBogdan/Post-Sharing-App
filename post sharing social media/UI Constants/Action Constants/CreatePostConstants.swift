//
//  CreatePostConstants.swift
//  post sharing social media
//
//  Created by Вадим on 28.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import UIKit

struct CreatePostConstants {
    
    public static let titleTop: CGFloat = 8.0
    public static let titleLeft: CGFloat = 16.0
    
    public static let bodyTopToTitleBottom: CGFloat = 8.0
    public static let bodyHorizontal: CGFloat = 12.0
    public static let bodyBottom: CGFloat = 12.0
    
    public static func bodyHeight(with titleHeight: CGFloat) -> CGFloat {
        return bodyTopToTitleBottom + bodyBottom + titleTop + titleHeight
    }
}

struct CreatePostColors {
    public static let placeholderColor: UIColor = {
        if #available(iOS 13, *) {
            return .placeholderText
        }
        
         return UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }()
}
