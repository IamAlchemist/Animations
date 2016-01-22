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
        dissolvedImageView.inputImages = [UIImage(named: "john-paulson")!,
            UIImage(named: "john-paulson")!,
            UIImage(named: "john-paulson")!]
        
        displayLink = CADisplayLink(target: self, selector: "update:")
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink?.paused = true
    }
    
    func update(displayLink : CADisplayLink) {
        progress += 0.02
        progress = progress > 1 ? 0 : progress;
        
        let alphaFilter = alphaImageFilter1D(progress)
        let backgroundFilter = whiteImageFilter1D()
        let inputFilter = pixellateImageFilter1D((1 - progress) * 100)
        let finalFilter = blendWithAlphaMaskImageFilter3D(backgroundFilter, inputFilter: inputFilter, alphaFilter: alphaFilter)
        
        dissolvedImageView.filter = finalFilter
    }
}

