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

class ContainerDefaultTransition : NSObject, UIViewControllerAnimatedTransitioning {
    let kChildViewPadding : CGFloat = 16
    let kDamping : CGFloat = 0.75
    let kInitialSpringVelocity : CGFloat = 0.5
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView()
            else { return }
        
        let goingRight = transitionContext.initialFrameForViewController(toViewController).origin.x < transitionContext.finalFrameForViewController(toViewController).origin.x
        let travelDistance = containerView.bounds.width + kChildViewPadding
        let traval = CGAffineTransformMakeTranslation(goingRight ? travelDistance : -travelDistance, 0)
        
        containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransformInvert(traval)
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0,
            usingSpringWithDamping: kDamping,
            initialSpringVelocity: kInitialSpringVelocity,
            options: .TransitionNone,
            
            animations: {
                fromViewController.view.transform = traval
                fromViewController.view.alpha = 0
                toViewController.view.transform = CGAffineTransformIdentity
                toViewController.view.alpha = 1
            },
            
            completion: { finished in
                fromViewController.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        )
    }
}
