//
//  ChildViewController.swift
//  DemoAnimations
//
//  Created by wizard on 5/2/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
import SnapKit

class ChildViewController : UIViewController {
    var themeColor : UIColor? {
        didSet {
            updateAppearance()
        }
    }
    
    override var title : String? {
        didSet {
            updateAppearance()
        }
    }
    
    override func loadView() {
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.textAlignment = .Center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view = UIView()
        view.addSubview(titleLabel)
        
        titleLabel.snp_makeConstraints { (make) in
            make.width.equalTo(view).multipliedBy(0.6)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = title
        updateAppearance()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(contentSizeCategoryDidChangeWithNotification(_:)), name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    deinit {
        if isViewLoaded() {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
    }

    func contentSizeCategoryDidChangeWithNotification(notification : NSNotification){
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.invalidateIntrinsicContentSize()
    }
    
    private var titleLabel : UILabel!
    
    private func updateAppearance() {
        if isViewLoaded() {
            titleLabel.text = title
            view.backgroundColor = themeColor
            view.tintColor = themeColor ?? UIColor(white: 1, alpha: 0.7)
        }
    }
}
