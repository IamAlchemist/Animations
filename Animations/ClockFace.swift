//
//  ClockFace.swift
//  Animations
//
//  Created by wizard on 2/7/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class ClockFace : CAShapeLayer {
    var time : NSDate? {
        didSet{
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let dateComponents = calendar.components([.Hour, .Minute], fromDate: time!)
            hourHand.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(dateComponents.hour) / 12 * 2 * CGFloat(M_PI)))
            minuteHand.setAffineTransform(CGAffineTransformMakeRotation(CGFloat(dateComponents.minute) / 60 * 2 * CGFloat(M_PI)))
        }
    }
    
    let hourHand : CAShapeLayer
    let minuteHand : CAShapeLayer
    
    override init() {
        hourHand = CAShapeLayer()
        minuteHand = CAShapeLayer()
        super.init()
        
        setup()
    }
    
    override init(layer: AnyObject) {
        hourHand = CAShapeLayer()
        minuteHand = CAShapeLayer()
        super.init(layer: layer)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        hourHand = CAShapeLayer()
        minuteHand = CAShapeLayer()
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup(){
        bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        path = UIBezierPath(ovalInRect: bounds).CGPath
        fillColor = UIColor.whiteColor().CGColor
        strokeColor = UIColor.blackColor().CGColor
        lineWidth = 4
        
        hourHand.path = UIBezierPath(rect: CGRect(x: -2, y: -80, width: 4, height: 80)).CGPath
        hourHand.fillColor = UIColor.blackColor().CGColor
        hourHand.position = CGPoint(x: bounds.width / 2, y: bounds.height/2)
        addSublayer(hourHand)
        
        minuteHand.path = UIBezierPath(rect: CGRect(x: -1, y: -90, width: 2, height: 90)).CGPath
        minuteHand.fillColor = UIColor.blackColor().CGColor
        minuteHand.position = CGPoint(x: bounds.width / 2 , y: bounds.height / 2)
        addSublayer(minuteHand)
    }
}
