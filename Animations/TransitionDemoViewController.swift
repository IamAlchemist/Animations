//
//  TransitionDemoViewController.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/15/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class TransitionDemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(TransitionDemoViewController.dismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

