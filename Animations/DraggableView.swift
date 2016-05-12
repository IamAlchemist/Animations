//
//  DraggableView.swift
//  DemoAnimations
//
//  Created by wizard on 5/4/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate : class {
    func draggableView(view: DraggableView, draggingEndedWithVelocity velocity: CGPoint)
    func draggableViewBeganDraggin(view: DraggableView)
}

class DraggableView : UIView {
    weak var delegate : DraggableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func didPan(recognizer : UIPanGestureRecognizer) {
        let point = recognizer.translationInView(superview)
        center = CGPoint(x: center.x, y: center.y + point.y)
        recognizer.setTranslation(CGPointZero, inView: superview)
        
        if case .Ended = recognizer.state {
            var velocity = recognizer.velocityInView(superview)
            velocity.x = 0
            delegate?.draggableView(self, draggingEndedWithVelocity: velocity)
        }
        else if case .Began = recognizer.state {
            delegate?.draggableViewBeganDraggin(self)
        }
    }
}