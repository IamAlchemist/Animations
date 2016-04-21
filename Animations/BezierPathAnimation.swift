//
//  BezierPathAnimation.swift
//  DemoAnimations
//
//  Created by Wizard Li on 4/21/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class BezierPathViewController : UIViewController {
    var shipLayer : CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 30, y: 150))
        bezierPath.addCurveToPoint(CGPoint(x: 330, y:150), controlPoint1: CGPoint(x: 105, y:0), controlPoint2: CGPoint(x: 255, y: 300))
        
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.CGPath
        pathLayer.fillColor = UIColor.clearColor().CGColor
        pathLayer.strokeColor = UIColor.redColor().CGColor
        pathLayer.lineWidth = 3
        view.layer.addSublayer(pathLayer)
        
        let shipLayer = CALayer()
        shipLayer.frame = CGRect(x: 30, y: 0, width: 64, height: 64)
        shipLayer.position = CGPoint(x: 30, y: 150)
        shipLayer.contents = UIImage(named: "Ship")?.CGImage
        view.layer.addSublayer(shipLayer)
        self.shipLayer = shipLayer
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 4
        animation.path = bezierPath.CGPath
        animation.rotationMode = kCAAnimationRotateAuto
        animation.delegate = self
        shipLayer.addAnimation(animation, forKey: nil)
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            let animation = CABasicAnimation()
            animation.keyPath = "transform.rotation"
            animation.duration = 2
            animation.byValue = NSNumber(double: M_PI * 2)
            
            shipLayer?.addAnimation(animation, forKey: nil)
        }
    }
}
