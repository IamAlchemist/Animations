//
//  DissolvedShowViewController.swift
//  Animations
//
//  Created by Wizard Li on 1/20/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class DissolvedShowAnimatedTrasition : NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
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
        dissolvedImageView.inputImages = [UIImage(named: "john-paulson")!]
        
        displayLink = CADisplayLink(target: self, selector: "update:")
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func update(displayLink : CADisplayLink) {
        progress += 0.02
        progress = progress > 1 ? 0 : progress;
        
//        let filter = pixellateImageFilter1D(progress * 100) |> alphaImageFilter1D(1-progress)
        let filter = alphaImageFilter1D(1-progress)
        dissolvedImageView.filter = filter
    }
}

