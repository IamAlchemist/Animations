//
//  Animator.swift
//  DemoAnimations
//
//  Created by wizard on 5/2/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

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
                                    fromViewController.view.alpha = 0.0
                                    toViewController.view.alpha = 1
            })
        { _ in
            fromViewController.view.transform = CGAffineTransformIdentity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

//class Animator : NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 1
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//        
//        guard let container = transitionContext.containerView(),
//            let toView = toViewController?.view
//            else { return }
//        
//        container.addSubview(toView)
//        toView.alpha = 0
//        
//        UIView.animateWithDuration(
//            transitionDuration(transitionContext),
//            animations: {
//                fromViewController?.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
//                toViewController?.view.alpha = 1
//            },
//            completion: { finished in
//                fromViewController?.view.transform = CGAffineTransformIdentity
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//            }
//        )
//    }
//    
//    func animationEnded(transitionCompleted: Bool) {
//    }
//}
