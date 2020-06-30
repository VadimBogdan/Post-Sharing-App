//
//  CreatePostViewController + Keyboard.swift
//  post sharing social media
//
//  Created by Вадим on 29.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import Foundation
import UIKit

extension CreatePostViewController {
    
    @objc func keyboardWillBeHidden() {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
        
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! CGRect).size
        
//        guard let active = activeTextContainer as? UIView else { return }
//
//        var bkgndRect = active.superview!.frame
//        bkgndRect.size.height = kbSize.height
//
//        active.superview?.frame = bkgndRect
//        scrollView.setContentOffset(CGPoint(x: 0, y: active.frame.origin.y - kbSize.height), animated: true)
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var rect = self.view.frame
        rect.size.height -= kbSize.height

        guard let active = activeTextContainer as? UIView else { return }

        let activeOrigin = CGPoint(x: active.bounds.origin.x, y: active.bounds.origin.y + active.bounds.height)

        if rect.contains(activeOrigin) {
            scrollView.scrollRectToVisible(active.frame, animated: true)
        }
    }
}

extension CreatePostViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = .zero
    }
}
