//
//  LayerAnimationViewController.swift
//  DemoAnimations
//
//  Created by wizard on 5/27/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

struct RD_popAnimationContext {
    static var context : Bool = false
}

class LayerAnimationViewController: UIViewController {
    @IBOutlet weak var orangeView: UIView!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("outside animation block: \(view.actionForLayer(view.layer, forKey: "position"))")
        
        let temp : Int? = nil
        print("\(temp), \(NSNull())")
        
        //        UIView.animateWithDuration(0.3) {
        //            self.view.alpha = 0.2
        //            print("in animation block: \(self.view.actionForLayer(self.view.layer, forKey: "opacity"))")
        //        }
    }
    
    @IBAction func showAnimation(sender: UIButton) {
        UIView.RD_popAnimationWithDuration(2) {
            self.orangeView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        }
        
        self.orangeView.transform = CGAffineTransformIdentity
    }
}

class RDInspectionLayer : CALayer {
    override func addAnimation(anim: CAAnimation, forKey key: String?) {
        print("adding animation \(anim.debugDescription), \(key)")
        super.addAnimation(anim, forKey: key)
    }
}

class RDInspectionView : UIView {
    override class func layerClass() -> AnyClass {
        return RDInspectionLayer.self
    }
}

extension UIView {
    public override class func initialize() {
        struct Static {
            static var token : dispatch_once_t = 0
        }
        
        if self !== UIView.self {
            return
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = #selector(NSObject.actionForLayer(_:forKey:))
            let swizzledSelector = #selector(RD_actionForLayer(_:forKey:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }
            else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    public class func RD_popAnimationWithDuration(duration: NSTimeInterval, animations:()->()) {
        RD_popAnimationContext.context = true
        
        animations();
        
        if let allStatus = RD_savedPopAnimationStates {
            for status in allStatus {
                guard let oldValue = status.oldValue,
                    let newValue = status.layer.valueForKey(status.keyPath)
                    else { continue }
                
                let anim = CAKeyframeAnimation(keyPath: status.keyPath)
                
                let easing : Float = 0.1
                
                let easeIn = CAMediaTimingFunction(controlPoints: 1.0, 0.0, (1.0-easing), 1.0)
                let easeOut = CAMediaTimingFunction(controlPoints: easing, 0.0, 0.0, 1.0)
                
                anim.duration = duration
                anim.keyTimes = [0, 0.1, 1]
                anim.values = [oldValue, newValue, oldValue]
                anim.timingFunctions = [easeIn, easeOut]
                
                status.layer.addAnimation(anim, forKey: status.keyPath)
            }
        }
        
        RD_savedPopAnimationStates?.removeAll()
        RD_popAnimationContext.context = false
    }
    
    func RD_actionForLayer(layer: CALayer, forKey event:String) -> CAAction? {
        if RD_popAnimationContext.context {
            UIView.RD_savedPopAnimationStates?.append(RDSavedPopAnimationState.savedStateWithLayer(layer, keyPath: event))
            return NSNull()
        }
        
        return RD_actionForLayer(layer, forKey: event)
    }
}

extension UIView {
    private struct AssociatedKeys {
        static var DescriptiveName = "rd_savedPopAnimationStates"
    }
    
    class var RD_savedPopAnimationStates: [RDSavedPopAnimationState]? {
        get {
            if objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) == nil {
                self.RD_savedPopAnimationStates = []
            }
            
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? [RDSavedPopAnimationState]
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    (newValue as NSArray),
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
}

class RDSavedPopAnimationState : NSObject {
    var layer : CALayer
    var keyPath : String
    var oldValue : AnyObject?
    
    static func savedStateWithLayer(layer: CALayer, keyPath: String) -> RDSavedPopAnimationState {
        return RDSavedPopAnimationState(layer: layer, keyPath: keyPath, oldValue: layer.valueForKey(keyPath))
    }
    
    init(layer: CALayer, keyPath: String, oldValue : AnyObject?) {
        self.layer = layer
        self.keyPath = keyPath
        self.oldValue = oldValue
        
        super.init()
    }
}
