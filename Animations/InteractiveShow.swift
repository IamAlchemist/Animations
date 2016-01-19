//
//  InteractiveShow.swift
//  Animations
//
//  Created by wizard on 1/19/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class InteractiveShowViewController : UIViewController {
    
    @IBAction func quit(sender: UIBarButtonItem) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

class InteractiveTransition : UIPercentDrivenInteractiveTransition {
}

class FadeAndScaleTransitionPush : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        transitionContext.containerView()?.addSubview(toViewController.view)
        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        toViewController.view.alpha = 0.0
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
            animations: {
                toViewController.view.transform = CGAffineTransformIdentity
                toViewController.view.alpha = 1.0
                fromViewController.view.alpha = 0.0
            })
            { _ in
                fromViewController.view.alpha = 1.0
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class FadeAndScaleTransitionPop : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        toViewController.view.alpha = 0
        transitionContext.containerView()?.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext),
            animations: {
                toViewController.view.alpha = 1
                fromViewController.view.alpha = 0
                fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            })
            { _ in
                fromViewController.view.alpha = 1.0
                fromViewController.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class InteractiveNavigationControllerDelegate : NSObject, UINavigationControllerDelegate {
    
    var navigationController : UINavigationController?
    
    lazy var pushTransition : UIViewControllerAnimatedTransitioning = {
        return FadeAndScaleTransitionPush()
    }()
    
    lazy var popTransition : UIViewControllerAnimatedTransitioning = {
        return FadeAndScaleTransitionPop()
    }()
    
    var interactiveTransition : UIViewControllerInteractiveTransitioning?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addPanGesture()
    }
    
    func addPanGesture() {
        if let nc = navigationController {
            let gesture = UIPanGestureRecognizer(target: self, action: "pan:")
            nc.view.addGestureRecognizer(gesture)
        }
    }
    
    func pan(recognizer: UIPanGestureRecognizer){
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .Push:
            return pushTransition
        case .Pop:
            return popTransition
        case .None:
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}