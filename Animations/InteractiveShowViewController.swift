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

//class FadeAndScaleTransitionPush : NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 1
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//        
//        transitionContext.containerView()?.addSubview(toViewController.view)
//        toViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
//        toViewController.view.alpha = 0.0
//        
//        UIView.animateWithDuration(transitionDuration(transitionContext),
//            animations: {
//                toViewController.view.transform = CGAffineTransformIdentity
//                toViewController.view.alpha = 1.0
//                fromViewController.view.alpha = 0.0
//            })
//            { _ in
//                fromViewController.view.alpha = 1.0
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        }
//    }
//}
//
//class FadeAndScaleTransitionPop : NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
//        return 1
//    }
//    
//    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//        
//        toViewController.view.alpha = 0
//        transitionContext.containerView()?.addSubview(toViewController.view)
//        
//        UIView.animateWithDuration(transitionDuration(transitionContext),
//            animations: {
//                toViewController.view.alpha = 1
//                fromViewController.view.alpha = 0
//                fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
//            })
//            { _ in
//                fromViewController.view.alpha = 1.0
//                fromViewController.view.transform = CGAffineTransformIdentity
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        }
//    }
//}

class InteractiveNavigationControllerDelegate : NSObject, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigationController: UINavigationController!
    
    lazy var pushTransition : UIViewControllerAnimatedTransitioning = {
        return FadeAndScaleTransitionPush()
    }()
    
    lazy var popTransition : UIViewControllerAnimatedTransitioning = {
        return FadeAndScaleTransitionPop()
    }()
    
    var interactiveTransition : UIPercentDrivenInteractiveTransition?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGesture()
    }
    
    func addGesture() {
        let rightGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(InteractiveNavigationControllerDelegate.rightPan(_:)))
        rightGesture.edges = .Right
        navigationController.view.addGestureRecognizer(rightGesture)
        
        let leftGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(InteractiveNavigationControllerDelegate.leftPan(_:)))
        leftGesture.edges = .Left
        navigationController.view.addGestureRecognizer(leftGesture)
    }
    
    func leftPan(recognizer: UIScreenEdgePanGestureRecognizer){
        switch recognizer.state {
        case .Began:
            if navigationController.viewControllers.count == 2 {
                interactiveTransition = UIPercentDrivenInteractiveTransition()
                navigationController.popViewControllerAnimated(true)
            }
        case .Changed:
            let translation = recognizer.translationInView(navigationController.view)
            let percentage = fabs(translation.x / CGRectGetWidth(navigationController.view.bounds))
            interactiveTransition?.updateInteractiveTransition(percentage)
        case .Ended:
            if recognizer.velocityInView(navigationController.view).x > 0 {
                interactiveTransition?.finishInteractiveTransition()
            }
            else {
                interactiveTransition?.cancelInteractiveTransition()
            }
            
            interactiveTransition = nil
        case .Cancelled, .Failed:
            interactiveTransition?.cancelInteractiveTransition()
            interactiveTransition = nil
        case .Possible:
            break
        }
    }
    
    func rightPan(recognizer: UIScreenEdgePanGestureRecognizer){
        
        switch recognizer.state {
        case .Began:
            if navigationController.viewControllers.count == 1 {
                interactiveTransition = UIPercentDrivenInteractiveTransition()
                navigationController.visibleViewController?.performSegueWithIdentifier("PushBlueEmptyControllerSegue", sender: self)
            }
        case .Changed:
            let translation = recognizer.translationInView(navigationController.view)
            let percentage = fabs(translation.x / CGRectGetWidth(navigationController.view.bounds))
            interactiveTransition?.updateInteractiveTransition(percentage)
        case .Ended:
            if recognizer.velocityInView(navigationController.view).x < 0 {
                interactiveTransition?.finishInteractiveTransition()
            }
            else {
                interactiveTransition?.cancelInteractiveTransition()
            }
            
            interactiveTransition = nil
        case .Cancelled, .Failed:
            interactiveTransition?.cancelInteractiveTransition()
            interactiveTransition = nil
        case .Possible:
            break
        }
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