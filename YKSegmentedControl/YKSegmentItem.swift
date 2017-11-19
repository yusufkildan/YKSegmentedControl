//
//  YKSegmentItem.swift
//  YKSegmentedControl
//
//  Created by yusuf_kildan on 17/11/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

class YKSegmentItem: UIView {
    weak var delegate: YKSegmentItemDelegate!
    
    fileprivate var titleLabel: UILabel!
    fileprivate var imageView: UIImageView!
    
    fileprivate var imageViewHeightConstraint: NSLayoutConstraint!
    
    var image: UIImage? {
        didSet {
            if let imageView = imageView {
                imageView.image = image
            }
        }
    }
    
    var title: String? {
        didSet {
            if let titleLabel = titleLabel {
                titleLabel.text = title
            }
        }
    }
    
    var font: UIFont? {
        didSet {
            if let font = font {
                titleLabel.font = font
            }
        }
    }
    
    var shouldDisplayImage: Bool? {
        didSet {
            if let shouldDisplayImage = shouldDisplayImage {
                if shouldDisplayImage == false {
                    imageViewHeightConstraint.constant = 0.0
                    titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                }
            }
        }
    }
    
    var textColor: UIColor? {
        didSet {
            if let titleLabel = titleLabel {
                titleLabel.textColor = textColor
            }
        }
    }
    
    // MARK: - Constructors
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.center
        
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0.0)
        imageViewHeightConstraint.isActive = true
        
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = NSTextAlignment.center
        
        self.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackground(_:))))
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = image {
            imageViewHeightConstraint.constant = frame.size.height
        }
    }
    
    // MARK: - Gestures
    
    func didTapBackground(_ recognizer: UITapGestureRecognizer) {
        delegate.ykSegmentItemDidReceiveTap(self)
    }
}

// MARK: - YKSegmentItemDelegate

protocol YKSegmentItemDelegate: NSObjectProtocol {
    func ykSegmentItemDidReceiveTap(_ segment: YKSegmentItem)
}
