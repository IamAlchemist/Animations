//
//  ClockFace3ViewController.swift
//  DemoAnimations
//
//  Created by Wizard Li on 4/21/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class ClockFace3ViewController : UIViewController {
    
    @IBOutlet weak var hourHand: UIImageView!
    @IBOutlet weak var minuteHand: UIImageView!
    @IBOutlet weak var secondHand: UIImageView!
    
    var timer : NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        minuteHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        secondHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        updateHandsAnimated(false)
    }
    
    func tick() {
        updateHandsAnimated(true)
    }
    
    func updateHandsAnimated(animated: Bool){
        
        func setAngle(angle: CGFloat, hand: UIView, animated: Bool) {
            let transform = CATransform3DMakeRotation(angle, 0, 0, 1)
            if animated {
                let animation = CABasicAnimation()
                animation.keyPath = "transform"
                animation.toValue = NSValue(CATransform3D: transform)
                animation.duration = 0.5
                animation.delegate = self
                animation.setValue(hand, forKey: "hand")
                hand.layer.addAnimation(animation, forKey: nil)
            }
            else {
                hand.layer.transform = transform
            }
        }
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let units : NSCalendarUnit = [.Hour, .Minute, .Second]
        let date = NSDate(timeIntervalSinceNow: 0)
        guard let components = calendar?.components(units, fromDate: date) else { return }
        let hourAngle = CGFloat(components.hour) / 12.0 * CGFloat(M_PI) * 2
        let minuteAngle = CGFloat(components.minute) / 60.0 * CGFloat(M_PI) * 2
        let secondAngle = CGFloat(components.second) / 60.0 * CGFloat(M_PI) * 2
        
        setAngle(hourAngle, hand: hourHand, animated: animated)
        setAngle(minuteAngle, hand: minuteHand, animated: animated)
        setAngle(secondAngle, hand: secondHand, animated: animated)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        guard let anim = anim as? CABasicAnimation else { return }
        guard let transform = anim.toValue?.CATransform3DValue else { return }
        let hand = anim.valueForKey("hand")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        hand?.layer.transform = transform
        CATransaction.commit()
    }
    
    
}