//
//  KeyFrameEasing.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/17/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class KeyFrameEasingViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    var ballView : UIImageView!
    
    var colorLayer : CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorLayer = CALayer()
        colorLayer.backgroundColor = UIColor.blueColor().CGColor
        colorLayer.frame = container.bounds
        
        container.layer.addSublayer(colorLayer)
        
        let ballImage = UIImage(named: "Ball")
        ballView = UIImageView(image: ballImage)
        container.addSubview(ballView)
    }
    
    @IBAction func changeColor(sender: UIButton) {
        colorLayer.removeAllAnimations()
        
        let animation = CAKeyframeAnimation()
        
        animation.keyPath = "backgroundColor"
        animation.duration = 5.0
        animation.values = [UIColor.blueColor().CGColor, UIColor.redColor().CGColor, UIColor.grayColor().CGColor, UIColor.blueColor().CGColor]
        
        let fn = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        animation.timingFunctions = [fn, fn, fn]
        
        colorLayer.addAnimation(animation, forKey: nil)
    }

    @IBAction func bounce(sender: UIButton) {
        animate()
    }
    
    private func animate() {
        ballView.center = CGPoint(x: 150, y: 32)
        
        let fromValue = NSValue(CGPoint: CGPoint(x: 150, y: 32))
        let toValue = NSValue(CGPoint: CGPoint(x: 150, y: 268))
        
        let numFrames = 60
        var frames = [NSValue]()
        
        for i in 0..<numFrames {
            var time = 1.0/Float(numFrames) * Float(i)
            time = bounceEaseOut(time)
            frames.append(interpolateFromValue(fromValue, toValue: toValue, time: time))
        }
        
        let keyframeAnimation = CAKeyframeAnimation()
        keyframeAnimation.keyPath = "position"
        keyframeAnimation.duration = 1.0
        keyframeAnimation.values = frames
        
        ballView.layer.position = CGPoint(x: 150, y: 268)
        ballView.layer.addAnimation(keyframeAnimation, forKey: nil)
    }
    
    private func interpolateFromValue(fromValue: NSValue, toValue:NSValue, time:Float) -> NSValue {
        let from = fromValue.CGPointValue()
        let to = toValue.CGPointValue()
        
        let result = CGPoint(x: interpolate(from.x, to.x, time), y: interpolate(from.y, to.y, time))
        return NSValue(CGPoint:result)
    }
    
    private func interpolate(from: CGFloat, _ to: CGFloat, _ time: Float) -> CGFloat {
        return (to - from) * CGFloat(time) + from;
    }
    
    private func bounceEaseOut(t: Float) -> Float {
        if (t < 4/11.0) {
            return (121 * t * t)/16.0;
        }
        else if (t < 8/11.0) {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        }
        else if (t < 9/10.0) {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
        
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
}






























