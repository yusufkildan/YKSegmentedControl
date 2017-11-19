//
//  ViewController.swift
//  YKSegmentedControl
//
//  Created by yusuf_kildan on 19/11/2017.
//  Copyright © 2017 yusuf_kildan. All rights reserved.
//

import UIKit

enum SegmentTypeWithImage: Int {
    case menu
    case comment
    case smile
    case search
    
    var selectedAsset: UIImage! {
        switch self {
        case .menu:
            return UIImage(named: "iconSegmentedControlMenuSelected")
        case .comment:
            return UIImage(named: "iconSegmentedControlCommentSelected")
        case .smile:
            return UIImage(named: "iconSegmentedControlSmileSelected")
        case .search:
            return UIImage(named: "iconSegmentedControlSearchSelected")
        }
    }
    
    var defaultAsset: UIImage! {
        switch self {
        case .menu:
            return UIImage(named: "iconSegmentedControlMenu")
        case .comment:
            return UIImage(named: "iconSegmentedControlComment")
        case .smile:
            return UIImage(named: "iconSegmentedControlSmile")
        case .search:
            return UIImage(named: "iconSegmentedControlSearch")
        }
    }
    
    static let allValues = [menu, comment, smile, search]
}

enum SegmentTypeWithTitle: Int {
    case first
    case second
    case third
    
    var title: String {
        switch self {
        case .first:
            return "First"
        case .second:
            return "Second"
        case .third:
            return "Third"
        }
    }
    
    static let allValues = [first, second, third]
}

class ViewController: UIViewController {
    
    @IBOutlet weak var simpleSegmentedControl: YKSegmetedControl!
    @IBOutlet weak var segmentedControlWithSelectionIndicator: YKSegmetedControl!
    @IBOutlet weak var segmentedControlWithImage: YKSegmetedControl!
    @IBOutlet weak var segmentedControlWithSelectionBox: YKSegmetedControl!
    @IBOutlet weak var segmentedControlWithBoxAndIndicator: YKSegmetedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleSegmentedControl.delegate = self
        simpleSegmentedControl.dataSource = self
        simpleSegmentedControl.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        
        segmentedControlWithSelectionIndicator.delegate = self
        segmentedControlWithSelectionIndicator.dataSource = self
        segmentedControlWithSelectionIndicator.font = UIFont.boldSystemFont(ofSize: 14.0)
        segmentedControlWithSelectionIndicator.selectionIndicatorStyle = YKSegmentedControlSelectionIndicatorStyle.bottom
        segmentedControlWithSelectionIndicator.tintColor = #colorLiteral(red: 0.9607843137, green: 0, blue: 0.02745098039, alpha: 1)
        
        
        segmentedControlWithImage.delegate = self
        segmentedControlWithImage.dataSource = self
        segmentedControlWithImage.tintColor = #colorLiteral(red: 0.9647058824, green: 0.6470588235, blue: 0.137254902, alpha: 1)
        segmentedControlWithImage.font = UIFont.boldSystemFont(ofSize: 14.0)
        segmentedControlWithImage.selectionIndicatorStyle = .bottom
        segmentedControlWithImage.selectionIndicatorHeight = 2.0
        segmentedControlWithImage.selectionIndicatorInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        
        
        segmentedControlWithSelectionBox.delegate = self
        segmentedControlWithSelectionBox.dataSource = self
        segmentedControlWithSelectionBox.font = UIFont.boldSystemFont(ofSize: 14.0)
        segmentedControlWithSelectionBox.tintColor = UIColor.black
        segmentedControlWithSelectionBox.selectionBoxStyle = YKSegmentedControlSelectionBoxStyle.default
        
        
        segmentedControlWithBoxAndIndicator.delegate = self
        segmentedControlWithBoxAndIndicator.dataSource = self
        segmentedControlWithBoxAndIndicator.font = UIFont.boldSystemFont(ofSize: 14.0)
        segmentedControlWithBoxAndIndicator.selectionIndicatorStyle = YKSegmentedControlSelectionIndicatorStyle.top
        segmentedControlWithBoxAndIndicator.tintColor = UIColor.black
        segmentedControlWithBoxAndIndicator.selectionBoxStyle = YKSegmentedControlSelectionBoxStyle.default
        
    }
}

// MARK: - YKSegmentedControlDelegate

extension ViewController: YKSegmentedControlDelegate {
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, didSelectItemAtIndex index: Int) {
        print("Tab Index: \(index)")
    }
    
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, shouldSelectTabAtIndex index: Int) -> Bool {
        return true
    }
}

// MARK: - YKSegmentedControlDataSource

extension ViewController: YKSegmetedControlDataSource {
    func numberOfSegments(_ segmentedControl: YKSegmetedControl) -> Int {
        if segmentedControl == segmentedControlWithImage {
            return SegmentTypeWithImage.allValues.count
        }
        
        return SegmentTypeWithTitle.allValues.count
    }
    
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, buttonTitleAtIndex index: Int) -> String? {
        if segmentedControl == segmentedControlWithImage {
            return nil
        }
        
        return SegmentTypeWithTitle.allValues[index].title
    }
    
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, buttonColorForState state: YKSegmetedControlState) -> UIColor? {
        if segmentedControl != self.segmentedControlWithImage {
            if state ==  YKSegmetedControlState.default{
                return UIColor.lightGray
            }
            
            return UIColor.black
        }
        
        return nil
    }
    
    func ykSegmentedControl(_ segmentedControl: YKSegmetedControl, buttonImageAtIndex index: Int, forState state: YKSegmetedControlState) -> UIImage? {
        if segmentedControl == segmentedControlWithImage {
            switch state {
            case .default:
                return SegmentTypeWithImage.allValues[index].defaultAsset
            case .selected:
                return SegmentTypeWithImage.allValues[index].selectedAsset
            }
        }
        
        return nil
    }
}
