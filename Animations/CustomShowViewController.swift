//
//  CustomShowViewController.swift
//  Animations
//
//  Created by Wizard Li on 1/19/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class CustomShowViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
    
    @IBAction func quit(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CustomShowViewController : UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push:
            return FadeAndScaleTransitionPush()
        case .Pop:
            return FadeAndScaleTransitionPop()
        case .None:
            return nil
        }
    }
    
}

