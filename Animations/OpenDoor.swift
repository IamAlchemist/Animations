//
//  OpenDoor.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/16/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
import SnapKit

class OpenDoorViewController: UIViewController {
    
    let autoReveseAnim = "AutoReverseAnimation"
    
    var container : UIView!
    var doorLayer : CALayer!
    
    var isAuto : Bool = false
    var gesture : UIPanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width:CGFloat = 128
        let height:CGFloat = 256
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        container.backgroundColor = UIColor.blueColor()
        view.addSubview(container)
        container.snp_makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        doorLayer = CALayer()
        doorLayer.frame = container.bounds
        doorLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        doorLayer.position = CGPoint(x: 0, y: 128)
        doorLayer.contents = UIImage(named: "Door")?.CGImage
        container.layer.addSublayer(doorLayer)
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0/500.0
        container.layer.sublayerTransform = perspective
        
        addAutoReverseAnimation()
        isAuto = true
    }
    
    @IBAction func toggle(sender: UIButton) {
        doorLayer.removeAllAnimations()
        
        if isAuto {
            gesture = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
            
            doorLayer.speed = 0.0
            
            let animation = CABasicAnimation()
            animation.keyPath = "transform.rotation.y"
            animation.toValue = NSNumber(double:-M_PI_2)
            animation.duration = 1.0
            doorLayer.addAnimation(animation, forKey: nil)
            
            view.addGestureRecognizer(gesture!)
        }
        else {
            doorLayer.speed = 1.0
            
            if let gesture = gesture {
                view.removeGestureRecognizer(gesture)
                self.gesture = nil
            }
            
            addAutoReverseAnimation()
        }
        
        isAuto = !isAuto
    }
    
    func panned(gesture : UIPanGestureRecognizer) {
        var x = gesture.translationInView(view).x
        x /= 200
        
        var timeOffset = doorLayer.timeOffset
        timeOffset = min(0.999, max(0.0, timeOffset - Double(x)))
        doorLayer.timeOffset = timeOffset
        
        gesture.setTranslation(CGPointZero, inView: view)
    }
    
    private func addAutoReverseAnimation() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = NSNumber(double: -M_PI_2)
        animation.duration = 2.0
        animation.autoreverses = true
        animation.repeatDuration = Double.infinity
        doorLayer.addAnimation(animation, forKey: autoReveseAnim)
    }
}
