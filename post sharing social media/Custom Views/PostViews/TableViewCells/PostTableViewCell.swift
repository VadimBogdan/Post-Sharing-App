//
//  PostTableViewCell.swift
//  post sharing social media
//
//  Created by Вадим on 27.06.2020.
//  Copyright © 2020 Vadym Bogdan. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    fileprivate let titleLabel = UILabel()
    fileprivate let bodyTextView = UITextView()
    fileprivate let creationDateLabel = UILabel()

    fileprivate var gradient: CAGradientLayer!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        setupUI()
    }
    
    fileprivate func setupUI() {
        setupGradient()
        setupStaticLabels()
        setupDynamicLabels()
    }
    
    fileprivate func setupGradient() {
        let yOffset = titleLabel.bounds.height + creationDateLabel.bounds.height
        gradient = Gradient.postSeparatorGradient(bounds: bounds, yViewsOffset: yOffset)
        self.contentView.layer.insertSublayer(gradient, at: 0)
    }
    
    fileprivate func setupStaticLabels() {
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        creationDateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        creationDateLabel.adjustsFontForContentSizeCategory = true
        titleLabel.adjustsFontForContentSizeCategory = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(creationDateLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        creationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: PostTableViewCellConstants.titleTop),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PostTableViewCellConstants.titleLeft),
                creationDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: PostTableViewCellConstants.creationDateTopToTitleBottom),
                creationDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PostTableViewCellConstants.creationDateLeft)]
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func setupDynamicLabels() {
        bodyTextView.isScrollEnabled = false
        bodyTextView.isEditable = false
        bodyTextView.font = UIFont.preferredFont(forTextStyle: .body)
        bodyTextView.adjustsFontForContentSizeCategory = true
        
        bodyTextView.textContainer.maximumNumberOfLines = 0
        bodyTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        contentView.addSubview(bodyTextView)
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [bodyTextView.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: PostTableViewCellConstants.bodyTopToCreationDateBottom),
            bodyTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PostTableViewCellConstants.bodyLeft),
            bodyTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: PostTableViewCellConstants.bodyRight),
            bodyTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: PostTableViewCellConstants.bodyBottom)]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let yOffset = titleLabel.bounds.height + creationDateLabel.bounds.height
        gradient.frame = Gradient.postSeparatorGradientFrame(bounds: bounds, yViewsOffset: yOffset)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureUI(withModel post: Post) {
        titleLabel.text = post.title
        creationDateLabel.text = post.creationDate
        bodyTextView.text = post.body
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension PostTableViewCell {
    
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
