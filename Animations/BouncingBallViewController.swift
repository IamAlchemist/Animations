//
//  BouncingBallViewController.swift
//  DemoAnimations
//
//  Custom Animation with CADisplayLink
//
//  Created by wizard lee on 7/16/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class BouncingBallViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    
    var ballView : UIImageView!
    var duration : NSTimeInterval = 0
    var timeOffset : NSTimeInterval = 0
    var fromValue : AnyObject!
    var toValue : AnyObject!
    
    var timer : NSTimer?
    
    var displayLink : CADisplayLink?
    var lastStep : NSTimeInterval = 0
    
    var usingCADisplayLink = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ballImage = UIImage(named: "Ball")
        ballView = UIImageView(image: ballImage)
        
        container.addSubview(ballView)
        
        animate()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animate()
    }
    
    private func interpolateFrom(from: Float, to: Float, time: Float) -> Float {
        return (to - from) * time + from
    }
    
    private func interpolateFromValue(fromValue: AnyObject, toValue: AnyObject, time: Float) -> AnyObject {
        guard let _fromValue = fromValue as? NSValue,
            _toValue = toValue as? NSValue
            else { return (time < 0.5) ? fromValue : toValue }
        
        let from = _fromValue.CGPointValue()
        let to = _toValue.CGPointValue()
        
        let x = CGFloat(interpolateFrom(Float(from.x), to: Float(to.x), time: time))
        let y = CGFloat(interpolateFrom(Float(from.y), to: Float(to.y), time: time))
        
        return NSValue(CGPoint: CGPoint(x: x, y: y))
    }
    
    private func bounceEaseOut(t: Float) -> Float {
        if (t < 4/11.0)
        {
            return (121 * t * t)/16.0;
        }
        else if (t < 8/11.0)
        {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        }
        else if (t < 9/10.0)
        {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
    
    private func animate() {
        ballView.center = CGPoint(x: 150, y: 32)
        
        duration = 1.0
        timeOffset = 0.0
        fromValue = NSValue(CGPoint: CGPoint(x:150, y:32))
        toValue = NSValue(CGPoint: CGPoint(x: 150, y: 268))
        
        if !usingCADisplayLink {
            
            timer?.invalidate()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1/60.0, target: self, selector: #selector(step(_:)), userInfo: nil, repeats: true)
        }
        else {
            
            lastStep = CACurrentMediaTime()
            
            displayLink = CADisplayLink(target: self, selector: #selector(displayLinkStep(_:)))
            displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        }
    }
    
    func step(step: NSTimer) {
        timeOffset = min(timeOffset + 1/60.0, duration)
        
        var time = Float(timeOffset / duration)
        
        time = bounceEaseOut(time)
        
        let position = interpolateFromValue(fromValue, toValue: toValue, time: time)
        
        ballView.center = (position as! NSValue).CGPointValue()
        
        if timeOffset >= duration {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func displayLinkStep(displayLink: CADisplayLink) {
        let thisStep = CACurrentMediaTime()
        let stepDuration = thisStep - lastStep
        lastStep = thisStep
        
        timeOffset = min(timeOffset + stepDuration, duration)
        
        var time = Float(timeOffset / duration)
        
        time = bounceEaseOut(time)
        
        let position = interpolateFromValue(fromValue, toValue: toValue, time: time)
        
        ballView.center = (position as! NSValue).CGPointValue()
        
        if timeOffset >= duration {
            self.displayLink?.invalidate()
            self.displayLink = nil
        }
    }
}
