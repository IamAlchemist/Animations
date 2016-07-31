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
    
    let distanceRange: CGFloat = 200;
    
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
        let rotate = (CGFloat(arc4random_uniform(360)) - 180)/180.0
        let distanceX = (CGFloat(arc4random_uniform(100)) - 50)/50.0
        let distanceY = (CGFloat(arc4random_uniform(100)) - 50)/50.0
        print("\(rotate), \(distanceX), \(distanceY)")
        animateWithLayer(myLayer, rotate: rotate, distance: CGPoint(x: distanceX, y: distanceY), duration: 2)
    }
    
    func animateWithLayer(layer:CALayer, rotate: CGFloat, distance: CGPoint, duration: CFTimeInterval) {
        
        let animation = CABasicAnimation()
        let fromTransform = CATransform3DIdentity
        var toTransform = CATransform3DIdentity
        
        let rotateDegree =  rotate * CGFloat(M_PI)
        
        toTransform = CATransform3DTranslate(toTransform, 0, 0, -1000)
        toTransform = CATransform3DRotate(toTransform, rotateDegree, 0, 0, 1)
        
        animation.keyPath = "transform"
        animation.fromValue = NSValue(CATransform3D: fromTransform)
        animation.toValue = NSValue(CATransform3D: toTransform)
        
        let animation2 = CABasicAnimation()
        
        let originalPosition = myLayer.position
        let toPosition = CGPoint(x: originalPosition.x + distance.x * distanceRange,
                                 y: originalPosition.y + distance.y * distanceRange)
        
        animation2.keyPath = "position"
        animation2.toValue = NSValue(CGPoint: toPosition)
        
        let animation3 = CABasicAnimation()
        animation3.keyPath = "opacity"
        animation3.toValue = NSNumber(float: 0)
        
        let animationGroups = CAAnimationGroup()
        animationGroups.animations = [animation, animation2, animation3]
        animationGroups.duration = duration
        animationGroups.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        myLayer.addAnimation(animationGroups, forKey: nil)
    }
}
