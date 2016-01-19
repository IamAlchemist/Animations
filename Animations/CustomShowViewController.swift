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
            return FadeAndScaleTransitioningPush()
        case .Pop:
            return FadeAndScaleTransitioningPop()
        case .None:
            return nil
        }
    }
    
}

class FadeAndScaleTransitioningPush : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        transitionContext.containerView()?.addSubview(toViewController.view)
        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        toViewController.view.alpha = 0.0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            fromViewController.view.alpha = 0.0
            toViewController.view.transform = CGAffineTransformIdentity
            toViewController.view.alpha = 1.0
            })
            { _ in
                fromViewController.view.alpha = 1.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class FadeAndScaleTransitioningPop : NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        transitionContext.containerView()?.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
            animations: {
                fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
                toViewController.view.alpha = 1
            })
            { _ in
                fromViewController.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}