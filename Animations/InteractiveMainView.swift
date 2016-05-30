//
//  Draggable.swift
//  DemoAnimations
//
//  Created by wizard on 5/4/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
import SnapKit

enum PaneState {
    case Open
    case Closed
}

class InteractiveMainView : UIView {
    private(set) var paneState : PaneState = .Closed
    var draggableView : DraggableView!
    var animator : UIDynamicAnimator!
    var paneBehavior : PaneBehavior?
    
    var targetPoint : CGPoint {
        get {
            return paneState == .Closed ? CGPoint(x: bounds.width / 2, y: bounds.height * 1.25) : CGPoint(x: bounds.width / 2, y: bounds.height / 2 + 100)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        draggableView = DraggableView(frame: CGRect(x: 0, y: bounds.height * 0.75, width: bounds.width, height: bounds.height))
        
        draggableView.backgroundColor = UIColor.grayColor()
        draggableView.layer.cornerRadius = 8
        draggableView.delegate = self

        addSubview(draggableView)
        
        draggableView.snp_makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(self)
            make.top.equalTo(self).offset(self.bounds.height * 0.75)
        }
        
        animator = UIDynamicAnimator(referenceView: self)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    func animatePaneWithInitialVelocity(initialVelocity : CGPoint) {
        if paneBehavior == nil {
            paneBehavior = PaneBehavior(item: self.draggableView)
        }
        
        paneBehavior?.targetPoint = targetPoint
        paneBehavior?.velocity = initialVelocity
        if let paneBehavior = paneBehavior {
            animator.addBehavior(paneBehavior)
        }
    }
    
    func didTap(tapRecognizer : UITapGestureRecognizer) {
        paneState = paneState == .Open ? .Closed : .Open
        animatePaneWithInitialVelocity(paneBehavior?.velocity ?? CGPointZero)
    }
}

extension InteractiveMainView : DraggableViewDelegate {
    func draggableViewBeganDraggin(view: DraggableView) {
        animator.removeAllBehaviors()
    }
    
    func draggableView(view: DraggableView, draggingEndedWithVelocity velocity: CGPoint) {
        let targetState : PaneState = velocity.y > 0 ? .Closed : .Open
        paneState = targetState
        animatePaneWithInitialVelocity(velocity)
    }
}

