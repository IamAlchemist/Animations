//
//  ImageExplosionViewController.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/25/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class ImageExplosionViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var myLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "john-paulson")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        myLayer.backgroundColor = UIColor.orangeColor().CGColor
        myLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        imageView.layer.addSublayer(myLayer)
        var perspective = CATransform3DIdentity
        perspective.m34 = -1/500.0
        imageView.layer.sublayerTransform = perspective
        myLayer.position = imageView.center
    }
    
    @IBAction func animate(sender: UIButton) {
        
        let animation = CABasicAnimation()
        let fromTransform = CATransform3DIdentity
        var toTransform = CATransform3DIdentity
        toTransform = CATransform3DTranslate(toTransform, 0, 0, -1000)
        toTransform = CATransform3DRotate(toTransform, CGFloat(M_PI_4), 0, 0, 1)
        
        animation.keyPath = "transform"
        animation.fromValue = NSValue(CATransform3D: fromTransform)
        animation.toValue = NSValue(CATransform3D: toTransform)
        
        let animation2 = CABasicAnimation()
        
        let originalPosition = myLayer.position
        let toPosition = CGPoint(x: originalPosition.x + 200, y: originalPosition.y + 200)
        
        animation2.keyPath = "position"
        animation2.toValue = NSValue(CGPoint: toPosition)
        
        let animation3 = CABasicAnimation()
        animation3.keyPath = "opacity"
        animation3.toValue = NSNumber(float: 0)
        
        let animationGroups = CAAnimationGroup()
        animationGroups.animations = [animation, animation2, animation3]
        animationGroups.duration = 2
        animationGroups.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        myLayer.addAnimation(animationGroups, forKey: nil)
    }
}
