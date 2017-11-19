//
//  YKSegmentedControl.swift
//  YKSegmentedControl
//
//  Created by yusuf_kildan on 18/11/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

enum YKSegmetedControlState {
    case `default`
    case selected
}

enum YKSegmentedControlSelectionIndicatorStyle {
    case none
    case top
    case bottom
}

enum YKSegmentedControlSelectionBoxStyle {
    case none
    case `default`
}

let YKSegmetedControlDefaultHeight: CGFloat = 44.0

class YKSegmetedControl: UIView {
    weak var delegate: YKSegmentedControlDelegate!
    weak var dataSource: YKSegmetedControlDataSource!
    
    // MARK: - Private Variables
    
    fileprivate var selectionIndicatorView: UIView!
    fileprivate var selectionIndicatorViewLeftConstraint: NSLayoutConstraint!
    fileprivate var selectionIndicatorViewWidth: CGFloat = 0.0
    
    fileprivate var selectionBoxView: UIView!
    fileprivate var selectionBoxViewLeftConstraint: NSLayoutConstraint!
    fileprivate var selectionBoxViewWidth: CGFloat = 0.0

    fileprivate var segmentItems: [YKSegmentItem]! = []
    
    fileprivate var segmentWidth: CGFloat = 0.0
    
    // MARK: - Public Variables
    
    var selectionIndicatorStyle: YKSegmentedControlSelectionIndicatorStyle = YKSegmentedControlSelectionIndicatorStyle.none
    var selectionIndicatorInsets: UIEdgeInsets = UIEdgeInsets.zero
    var selectionIndicatorHeight: CGFloat = 3.0
    
    var selectionBoxStyle: YKSegmentedControlSelectionBoxStyle = YKSegmentedControlSelectionBoxStyle.none
    var selectionBoxColor: UIColor = UIColor.black.withAlphaComponent(0.2)
    var selectionBoxCornerRadius: CGFloat = 0
    var selectionBoxEdgeInsets = UIEdgeInsets.zero
    
    var font: UIFont? {
        didSet {
            for segmentItem in segmentItems {
                segmentItem.font = font
            }
        }
    }
    
    var selectedIndex: Int! = 0 {
        didSet {
            updateSelectionWith(Index: selectedIndex, animated: true)
        }
    }

    override var tintColor: UIColor! {
        didSet {
            if let view = selectionIndicatorView {
                view.backgroundColor = tintColor
            }
        }
    }
    
    // MARK: - Create Interface
    
    fileprivate func createInterface() {
        let numberOfSegments = dataSource.numberOfSegments(self)
        
        segmentWidth = (frame.size.width / CGFloat(numberOfSegments))
        
        var prevSegmentItem: YKSegmentItem?
        
        for index in 0..<numberOfSegments {
            let segmentItem = YKSegmentItem()
            segmentItem.translatesAutoresizingMaskIntoConstraints = false
            segmentItem.delegate = self
            
            if let image = dataSource.ykSegmentedControl(self, buttonImageAtIndex: index, forState: YKSegmetedControlState.default) {
                segmentItem.image = image
            }else {
                segmentItem.shouldDisplayImage = false
            }
            
            segmentItem.font = font
            segmentItem.title = dataSource.ykSegmentedControl(self, buttonTitleAtIndex: index)
            
            addSubview(segmentItem)
            
            if prevSegmentItem != nil {
                segmentItem.leftAnchor.constraint(equalTo: prevSegmentItem!.rightAnchor).isActive = true
            } else {
                segmentItem.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            }
            
            segmentItem.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            segmentItem.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            segmentItem.widthAnchor.constraint(equalToConstant: segmentWidth).isActive = true
            
            prevSegmentItem = segmentItem
            
            segmentItems.append(segmentItem)
        }
        
        if selectionIndicatorStyle != YKSegmentedControlSelectionIndicatorStyle.none {
            selectionIndicatorView = UIView()
            selectionIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            selectionIndicatorView.backgroundColor = tintColor
            
            addSubview(selectionIndicatorView)
            
            if selectionIndicatorStyle == YKSegmentedControlSelectionIndicatorStyle.top {
                selectionIndicatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            } else if selectionIndicatorStyle == YKSegmentedControlSelectionIndicatorStyle.bottom {
                selectionIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            }
            
            selectionIndicatorViewWidth = segmentWidth - (selectionIndicatorInsets.left + selectionIndicatorInsets.right)
            selectionIndicatorView.widthAnchor.constraint(equalToConstant: selectionIndicatorViewWidth).isActive = true
            selectionIndicatorView.heightAnchor.constraint(equalToConstant: selectionIndicatorHeight).isActive = true
            selectionIndicatorViewLeftConstraint = selectionIndicatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0)
            selectionIndicatorViewLeftConstraint.isActive = true
        }
        
        if selectionBoxStyle == YKSegmentedControlSelectionBoxStyle.default {
            selectionBoxView = UIView()
            selectionBoxView.backgroundColor = selectionBoxColor
            selectionBoxView.translatesAutoresizingMaskIntoConstraints = false
            selectionBoxView.layer.masksToBounds = true
            selectionBoxView.layer.cornerRadius = selectionBoxCornerRadius
            
            addSubview(selectionBoxView)
            sendSubview(toBack: selectionBoxView)
            
            selectionBoxViewWidth = segmentWidth - (selectionBoxEdgeInsets.left + selectionBoxEdgeInsets.right)
            selectionBoxView.widthAnchor.constraint(equalToConstant: selectionBoxViewWidth).isActive = true
            selectionBoxView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            selectionBoxView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            selectionBoxViewLeftConstraint = selectionBoxView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0)
            selectionBoxViewLeftConstraint.isActive = true
        }
        
        updateSelectionWith(Index: selectedIndex, animated: false)
    }
    
    // MARK: - Selection
    
    fileprivate func updateSelectionWith(Index index: Int,animated: Bool) {
        
        if selectionIndicatorStyle != YKSegmentedControlSelectionIndicatorStyle.none {
            guard let selectionIndicatorViewLeftConstraint = selectionIndicatorViewLeftConstraint else {
                return
            }
            
            selectionIndicatorViewLeftConstraint.constant = (CGFloat(index) * segmentWidth) + selectionIndicatorInsets.left
            
            if animated {
                UIView.animate(withDuration: 0.33, animations: {
                    self.layoutIfNeeded()
                })
            }else {
                self.layoutIfNeeded()
            }
        }
        
        if selectionBoxStyle == YKSegmentedControlSelectionBoxStyle.default {
            guard let selectionBoxViewLeftConstraint = selectionBoxViewLeftConstraint else {
                return
            }
            
            selectionBoxViewLeftConstraint.constant = (CGFloat(index) * segmentWidth) + selectionBoxEdgeInsets.left
            
            if animated {
                UIView.animate(withDuration: 0.33, animations: {
                    self.layoutIfNeeded()
                })
            }else {
                self.layoutIfNeeded()
            }
        }
        
        for index in 0..<segmentItems.count {
            let segmentItem = segmentItems[index]
            
            var state = YKSegmetedControlState.default
            
            if index == selectedIndex {
                state = YKSegmetedControlState.selected
            }
            
            segmentItem.textColor = dataSource.ykSegmentedControl(self, buttonColorForState: state)
            segmentItem.title = dataSource.ykSegmentedControl(self, buttonTitleAtIndex: index)
            segmentItem.image = dataSource.ykSegmentedControl(self, buttonImageAtIndex: index, forState: state)
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if segmentItems.count == 0 {
            createInterface()
        }
    }
}

// MARK: - YKSegmentedControlDelegate

@objc protocol YKSegmentedControlDelegate: NSObjectProtocol {
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, didSelectItemAtIndex index: Int)
    @objc optional func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, shouldSelectTabAtIndex index: Int) -> Bool
}

// MARK: - YKSegmetedControlDataSource

protocol YKSegmetedControlDataSource: NSObjectProtocol {
    func numberOfSegments(_ segmentedControl: YKSegmetedControl) -> Int
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, buttonImageAtIndex index: Int, forState state: YKSegmetedControlState) -> UIImage?
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, buttonTitleAtIndex index: Int) -> String?
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, buttonColorForState state: YKSegmetedControlState) -> UIColor?
}

// MARK: - YKSegmentItemDelegate

extension YKSegmetedControl: YKSegmentItemDelegate {
    func ykSegmentItemDidReceiveTap(_ segment: YKSegmentItem) {
        if let index = segmentItems.index(of: segment) {
            if delegate.responds(to: #selector(YKSegmentedControlDelegate.ykSegmentedControl(_:shouldSelectTabAtIndex:))) {
                if delegate.ykSegmentedControl!(self, shouldSelectTabAtIndex: index) {
                    selectedIndex = index
                }
            }else {
                selectedIndex = index
            }
            
            delegate.ykSegmentedControl(self, didSelectItemAtIndex: index)
        }
    }
}
