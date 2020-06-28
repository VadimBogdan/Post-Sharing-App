//
//  Gradient.swift
//  post sharing social media
//
//  Created by Вадим on 27.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import UIKit

struct Gradient {
    
    public static func postSeparatorGradient(bounds: CGRect, yViewsOffset: CGFloat) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.white.cgColor, #colorLiteral(red: 0.02489590272, green: 0.3996174932, blue: 0.7851334214, alpha: 1).cgColor, #colorLiteral(red: 0.01884338818, green: 0.2417946458, blue: 0.4914121032, alpha: 1).cgColor, #colorLiteral(red: 0.02489590272, green: 0.3996174932, blue: 0.7851334214, alpha: 1).cgColor, UIColor.white.cgColor]
        gradient.frame = Gradient.postSeparatorGradientFrame(bounds: bounds, yViewsOffset: yViewsOffset)
        
        gradient.startPoint = CGPoint(x: 0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.locations = [NSNumber(0.0), NSNumber(0.2),  NSNumber(0.5), NSNumber(0.8), NSNumber(1)]
        
        return gradient
    }
    
    public static func postSeparatorGradientFrame(bounds: CGRect, yViewsOffset: CGFloat) -> CGRect {
         let gradientSize = CGSize(width: bounds.width * 0.85, height: 2),
            gradientOriginX = bounds.width * 0.075,
            gradientOriginY = Gradient.yOrigin(yViewsOffset)
        return CGRect(origin: CGPoint(x: gradientOriginX, y: gradientOriginY), size: gradientSize)
    }
    
    fileprivate static func yOrigin(_ yViewsOffset: CGFloat) -> CGFloat {
        return yViewsOffset +
            PostTableViewCellConstants.titleTopOffset +
            PostTableViewCellConstants.creationDateTopOffsetToTitleBottom + 6
    }
}
