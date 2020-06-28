//
//  String + FontSize.swift
//  post sharing social media
//
//  Created by Вадим on 27.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /**
     *  Calculates size of a font specified. Used primarly to see how much space UILabel will take.
     */
    func sizeOfString(withFont font: UIFont) -> CGSize {
        let fontAttrs = [NSAttributedString.Key.font : font]
        return self.size(withAttributes: fontAttrs)
    }
}
