//
//  KeyFrameViewController.swift
//  DemoAnimations
//
//  Created by Wizard Li on 4/21/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class GroupAnimViewController : UIViewController {
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0, y: 150))
        bezierPath.addCurveToPoint(CGPoint(x: 300, y: 150), controlPoint1: CGPoint(x: 75, y: 0), controlPoint2:CGPoint(x: 225, y: 300))
        
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.CGPath
        pathLayer.fillColor = UIColor.clearColor().CGColor
        pathLayer.strokeColor = UIColor.redColor().CGColor
        pathLayer.lineWidth = 3
        container.layer.addSublayer(pathLayer)
        
        let colorLayer = CALayer()
        colorLayer.frame = CGRectMake(0, 0, 64, 64)
        colorLayer.position = CGPoint(x: 0, y: 150)
        colorLayer.backgroundColor = UIColor.greenColor().CGColor
        container.layer.addSublayer(colorLayer)
        
        let animation1 = CAKeyframeAnimation()
        animation1.keyPath = "position"
        animation1.path = bezierPath.CGPath
        animation1.rotationMode = kCAAnimationRotateAuto
        
        let animation2 = CABasicAnimation()
        animation2.keyPath = "backgroundColor"
        animation2.toValue = UIColor.redColor().CGColor
        
        let grounp = CAAnimationGroup()
        grounp.animations = [animation1, animation2]
        grounp.duration = 4
        colorLayer.addAnimation(grounp, forKey: nil)
    }
}
