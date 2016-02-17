//
//  ClockFace2.swift
//  Animations
//
//  Created by wizard on 2/10/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class ClockFace2 : CALayer {
    
    @NSManaged var time : Float
    
    override init(){
        super.init()
        setup()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        
        if let layer = layer as? ClockFace2 {
            time = layer.time
        }
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        setNeedsDisplay()
    }
    
    override class func needsDisplayForKey(key: String) -> Bool{
        if key == "time" {
            return true
        }
        
        return super.needsDisplayForKey(key)
    }
    
    override func actionForKey(event: String) -> CAAction? {
        if event == "time" {
            let customAnimation = CABasicAnimation(keyPath: event)
            customAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            customAnimation.fromValue = (presentationLayer() as! ClockFace2).time
            return customAnimation
        }
        
        return super.actionForKey(event)
    }
    
    override func display() {
        var time : Float = 0
        
        if let layer = presentationLayer() {
            time = (layer as! ClockFace2).time
            print("time : \(time)")
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(ctx, 4)
        CGContextStrokeEllipseInRect(ctx, CGRectInset(bounds, 2, 2))
        
        var angle = time / 12 * 2 * Float(M_PI)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        CGContextSetLineWidth(ctx, 4)
        CGContextMoveToPoint(ctx, center.x, center.y)
        CGContextAddLineToPoint(ctx, center.x + CGFloat(sin(angle) * 80), center.y - CGFloat(cos(angle) * 80))
        CGContextStrokePath(ctx)
        
        angle = (time - floor(time)) * 2.0 * Float(M_PI)
        CGContextSetLineWidth(ctx, 2)
        CGContextMoveToPoint(ctx, center.x, center.y)
        CGContextAddLineToPoint(ctx, center.x + CGFloat(sin(angle) * 90), center.y - CGFloat(cos(angle) * 90))
        CGContextStrokePath(ctx)
        
        contents = UIGraphicsGetImageFromCurrentImageContext().CGImage
        
        UIGraphicsEndImageContext()
    }
}
