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
    
    var colorLayer : CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorLayer = CALayer()
        colorLayer.backgroundColor = UIColor.blueColor().CGColor
        colorLayer.frame = container.bounds
        
        container.layer.addSublayer(colorLayer)
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        colorLayer.frame = container.bounds
//    }
    
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
}
