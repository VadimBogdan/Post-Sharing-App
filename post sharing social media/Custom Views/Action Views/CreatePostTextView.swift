//
//  CreatePostTextView.swift
//  post sharing social media
//
//  Created by Вадим on 28.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit

/// Extended for placeholder text
class CreatePostTextView: UITextView {

    fileprivate var placeholderLabel = UILabel()
    fileprivate var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    convenience init(placeholderText: String = "", placeholderColor: UIColor = CreatePostColors.placeholderColor) {
        self.init(frame: .zero, textContainer: nil)
        placeholderLabel.text = placeholderText
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = UIFont.preferredFont(forTextStyle: .body)
        placeholderLabel.adjustsFontForContentSizeCategory = true
        placeholderLabel.sizeToFit()
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textDidChangeNotificationName = UITextView.textDidChangeNotification,
        textDidEndEditingNotificationName = UITextView.textDidEndEditingNotification
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textInTextViewDidChange), name: textDidChangeNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textInTextViewDidEndEditing), name: textDidEndEditingNotificationName, object: nil)
        
        addSubview(placeholderLabel)
    }
    
    @objc fileprivate func textInTextViewDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    @objc fileprivate func textInTextViewDidEndEditing() {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            text = ""
        }
        textInTextViewDidChange()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePlaceholderLabelConstraints()
    }
    
    fileprivate func updatePlaceholderLabelConstraints() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .greaterThanOrEqual,
            toItem: placeholderLabel,
            attribute: .height,
            multiplier: 1.0,
            constant: textContainerInset.top + textContainerInset.bottom
        ))
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
            ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        let textDidChangeNotificationName = UITextView.textDidChangeNotification,
        textDidEndEditingNotificationName = UITextView.textDidEndEditingNotification
        
        NotificationCenter.default.removeObserver(self, name: textDidChangeNotificationName, object: nil)
        NotificationCenter.default.removeObserver(self, name: textDidEndEditingNotificationName, object: nil)
    }
}
