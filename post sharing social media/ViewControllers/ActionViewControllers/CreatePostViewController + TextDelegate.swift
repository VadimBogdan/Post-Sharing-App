//
//  CreatePostViewController + TextDelegate.swift
//  post sharing social media
//
//  Created by Вадим on 29.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import UIKit

extension CreatePostViewController: UITextViewDelegate & UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextContainer = textField
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextContainer = textView
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextContainer = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextContainer = nil
    }
}
