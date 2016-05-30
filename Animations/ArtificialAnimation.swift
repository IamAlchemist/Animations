//
//  ArtificialAnimation.swift
//  DemoAnimations
//
//  Created by wizard on 5/5/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//
//  http://objccn.io/issue-12-6/

import UIKit

protocol ArtificialAnimation {
    func animationTick(dt : CFTimeInterval, inout finished : Bool)
}

private var ScreenAnimationDriverKey : Int = 0

class ArtificialAnimator<T: ArtificialAnimation where T: Hashable> : NSObject {
    
    class func animatorWithScreen(screen : UIScreen) -> ArtificialAnimator {
        let _screen = screen ?? UIScreen.mainScreen()
        
        var driver : ArtificialAnimator? = (objc_getAssociatedObject(self, &ScreenAnimationDriverKey) as? ArtificialAnimator)
        
        if driver == nil {
            driver = ArtificialAnimator(screen: _screen)
            objc_setAssociatedObject(
                self,
                &ScreenAnimationDriverKey,
                driver,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return driver!
    }

    func addAnimation(animatable : T) {
        animations.insert(animatable)
        if animations.count == 1 {
            displayLink?.paused = false
        }
    }
    
    func removeAnimation(animatable : T) {
        animations.remove(animatable)
        if animations.count == 0 {
            displayLink?.paused = true
        }
    }
    
    private var displayLink : CADisplayLink? = nil
    private var animations = Set<T>()
        
    private init(screen : UIScreen) {
        super.init()
        displayLink = screen.displayLinkWithTarget(self, selector: #selector(animationTick(_:)))
        displayLink?.paused = true
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func animationTick(displayLink : CADisplayLink) {
        let dt = displayLink.duration
        
        let animationsCopy = animations
        for animatable in animationsCopy {
            var finished = false
            animatable.animationTick(dt, finished: &finished)
            if finished {
                animations.remove(animatable)
            }
        }
        
        if animations.count == 0 {
            displayLink.paused = true
        }
    }
}

extension UIView {
    func animator() -> ArtificialAnimator<UINTSpringAnimation>? {
        if let window = self.window {
            return ArtificialAnimator<UINTSpringAnimation>.animatorWithScreen(window.screen)
        }
        else {
            return nil
        }
    }
}