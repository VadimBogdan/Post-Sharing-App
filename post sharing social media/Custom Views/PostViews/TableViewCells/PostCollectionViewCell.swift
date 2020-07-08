//
//  PostTableViewCell.swift
//  post sharing social media
//
//  Created by Вадим on 27.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit
import Model

class PostCollectionViewCell: UICollectionViewCell {
    
    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    fileprivate lazy var bodyTextView: UITextView = {
        let bodyTextView = UITextView()
        bodyTextView.isScrollEnabled = false
        bodyTextView.isEditable = false
        bodyTextView.font = UIFont.preferredFont(forTextStyle: .body)
        bodyTextView.adjustsFontForContentSizeCategory = true
        
        bodyTextView.textContainer.maximumNumberOfLines = 0
        bodyTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        return bodyTextView
    }()
    
    fileprivate lazy var creationDateLabel: UILabel = {
        let creationDateLabel = UILabel()
        creationDateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        creationDateLabel.adjustsFontForContentSizeCategory = true
        creationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return creationDateLabel
    }()

    fileprivate lazy var gradient: CAGradientLayer = {
        let yOffset = titleLabel.bounds.height + creationDateLabel.bounds.height
        let gradient = Gradient.postSeparatorGradient(bounds: bounds, yViewsOffset: yOffset)
        contentView.layer.insertSublayer(gradient, at: 0)
        return gradient
    }()
    
    fileprivate lazy var width: NSLayoutConstraint = {
        let constraint = contentView.widthAnchor
            .constraint(equalToConstant: bounds.size.width)
         constraint.isActive = true
        return constraint
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(bodyTextView)
    }
    
    fileprivate func setupConstraints() {
        // title and creation date labels
        NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: PostTableViewCellConstants.titleTop),
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PostTableViewCellConstants.titleLeft),
        creationDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: PostTableViewCellConstants.creationDateTopToTitleBottom),
        creationDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PostTableViewCellConstants.creationDateLeft)
        ])
        // body textview
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: PostTableViewCellConstants.bodyTopToCreationDateBottom),
            bodyTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PostTableViewCellConstants.bodyLeft),
            bodyTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: PostTableViewCellConstants.bodyRight),
            bodyTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: PostTableViewCellConstants.bodyBottom)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let yOffset = titleLabel.bounds.height + creationDateLabel.bounds.height
        gradient.frame = Gradient.postSeparatorGradientFrame(bounds: bounds, yViewsOffset: yOffset)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        width.constant = targetSize.width
        
        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: targetSize.width, height: 1),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: verticalFittingPriority)
        
        return size
    }
    
    func configureUI(withModel post: Post) {
        let dateTime = Int(post.createdAt)!
        
        titleLabel.text = post.title
        creationDateLabel.text = Date(timeIntervalSince1970: TimeInterval(dateTime)).toLocalized()
        bodyTextView.text = post.body
        
        titleLabel.sizeToFit()
        creationDateLabel.sizeToFit()
        bodyTextView.sizeToFit()
    }
}

extension PostCollectionViewCell {
    
    public static func calculateExpectedHeightOfViews() -> CGFloat {
        /// Static labels' height
        let placeholder = "Test" // only to check height!
        let titleHeightSize = placeholder.sizeOfString(withFont: UIFont.preferredFont(forTextStyle: .title3)),
            creationDateSize = placeholder.sizeOfString(withFont: UIFont.preferredFont(forTextStyle: .subheadline))
        let heightOfLabels = (titleHeightSize.height + creationDateSize.height).rounded(.toNearestOrEven)
        
        let heightOfConstraints = PostTableViewCellConstants.titleTop +
                                PostTableViewCellConstants.creationDateTopToTitleBottom +
                                PostTableViewCellConstants.bodyTopToCreationDateBottom
        
        let totalHeight = heightOfLabels + heightOfConstraints
        ///
//        #if DEBUG
//            print(heightOfLabels, titleHeightSize, creationDateSize)
//        #endif
        return totalHeight
    }
}
