//
//  DissolvedShowViewController.swift
//  Animations
//
//  Created by Wizard Li on 1/20/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class DissolvedShowAnimatedTrasition : NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration : NSTimeInterval = 1
    var animatingView = FilteredImageView(frame: CGRectZero)
    var displayLink : CADisplayLink!
    var startTime : NSTimeInterval = 0
    var progress : Double = 0
    
    var transitionContext : UIViewControllerContextTransitioning!
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        animatingView.backgroundColor = UIColor.whiteColor()
        displayLink = CADisplayLink(target: self, selector: "update:")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.paused = true
    }
    
    func update(displayLink: CADisplayLink){
        if startTime == 0 {
            startTime = displayLink.timestamp
        }
        progress = max(min((displayLink.timestamp - startTime) / duration, 1), Double(0))
        animatingView.filter = dissolveFilter2DWithProgress(Float(progress))
        
        if progress == 1 {
            finishInteractiveTransition()
        }
    }
    
    func finishInteractiveTransition() {
        displayLink.paused = true
        animatingView.removeFromSuperview()
        transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view.alpha = 1
        transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.alpha = 1
        transitionContext.completeTransition(true)
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let toView = toViewController.view
        let fromView = fromViewController.view
        
        let containerView = transitionContext.containerView()!
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        let sourceImage = fromView.snapshot()
        let targeImage = toView.snapshot()
        
        animatingView.frame = containerView.bounds
        animatingView.inputImages = [sourceImage, targeImage]
        
        toView.alpha = 0
        
        containerView.addSubview(animatingView)
        startTime = 0
        displayLink.paused = false
    }
}

class DissolvedShowNavigationDelegate : NSObject, UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .Push:
            return DissolvedShowAnimatedTrasition()
        case .Pop:
            return nil
        case .None:
            return nil
        }
    }
}

class DissolvedShowViewController : UIViewController {
    
    @IBOutlet weak var dissolvedImageView: FilteredImageView!
    
    @IBAction func quit(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var displayLink : CADisplayLink?
    
    var progress : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dissolvedImageView.contentMode = .ScaleAspectFit
        dissolvedImageView.inputImages = [UIImage(named: "john-paulson")!,UIImage(named: "john-paulson-2")!]
        
        displayLink = CADisplayLink(target: self, selector: "update:")
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink?.paused = true
    }
    
    func update(displayLink : CADisplayLink) {
        progress += 0.02
        progress = progress > 1 ? 0 : progress;
        
        dissolvedImageView.filter = dissolveFilter2DWithProgress(progress)
    }
}

