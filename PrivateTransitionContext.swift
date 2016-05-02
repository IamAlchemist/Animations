//
//  PrivateTransitionContext.swift
//  DemoAnimations
//
//  Created by wizard on 5/2/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class PrivateTransitionContext : NSObject, UIViewControllerContextTransitioning {
    
    var completionBlock : ((Bool) -> Void)?
    var animated : Bool = false
    var interactive : Bool = false
    private var _presentationStyle : UIModalPresentationStyle
    
    init?(fromViewController : UIViewController,
         toViewController : UIViewController,
         goingRight : Bool)
    {
        precondition(fromViewController.isViewLoaded(), "from view controller is not loaded")
        precondition(fromViewController.view.superview != nil, "from view doesn't have superview")
        
        _presentationStyle = .Custom
        _containerView = fromViewController.view.superview!
        viewControllers = [UITransitionContextFromViewControllerKey : fromViewController,
                           UITransitionContextToViewControllerKey: toViewController]
        
        views = [UITransitionContextFromViewKey : fromViewController.view,
                 UITransitionContextToViewKey: toViewController.view]
        
        let travelDistance = (goingRight ? -_containerView.bounds.width : _containerView.bounds.width)
        
        disappearingFromRect = _containerView.bounds
        disappearingToRect = CGRectOffset(_containerView.bounds, travelDistance, 0)
        appearingToRect = _containerView.bounds
        appearingFromRect = CGRectOffset(_containerView.bounds, -travelDistance, 0)

        super.init()
    }
    
    func presentationStyle() -> UIModalPresentationStyle {
        return _presentationStyle
    }
    
    func targetTransform() -> CGAffineTransform {
        return CGAffineTransformIdentity
    }
    
    func isAnimated() -> Bool {
        return false
    }
    
    func isInteractive() -> Bool {
        return false
    }
    
    func completeTransition(didComplete: Bool) {
        completionBlock?(didComplete)
    }
    
    func transitionWasCancelled() -> Bool {
        return false
    }

    func initialFrameForViewController(vc: UIViewController) -> CGRect {
        if vc == viewControllers[UITransitionContextFromViewControllerKey] {
            return disappearingFromRect
        }
        else {
            return appearingFromRect
        }
    }
    
    func finalFrameForViewController(vc: UIViewController) -> CGRect {
        if vc == viewControllers[UITransitionContextFromViewControllerKey] {
            return disappearingToRect
        }
        else {
            return appearingToRect
        }
    }
    
    func viewForKey(key: String) -> UIView? {
        return views[key]
    }
    
    func viewControllerForKey(key: String) -> UIViewController? {
        return viewControllers[key]
    }
    
    func updateInteractiveTransition(percentComplete: CGFloat) { }
    func finishInteractiveTransition() { }
    func cancelInteractiveTransition() { }
    
    func containerView() -> UIView? {
        return _containerView
    }
    
    
    private var viewControllers : [String : UIViewController]
    private var views : [String : UIView]
    private var disappearingFromRect : CGRect
    private var appearingFromRect : CGRect
    private var disappearingToRect : CGRect
    private var appearingToRect : CGRect

    private let _containerView : UIView
    

    
    
    
}
