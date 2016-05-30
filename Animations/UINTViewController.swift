//
//  UINTViewController.swift
//  DemoAnimations
//
//  Created by Wizard Li on 5/30/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
import SnapKit

class UINTViewController : UIViewController {
    
    var panState : PaneState = .Closed
    var draggableView : DraggableView!
    var springAnimation : UINTSpringAnimation?
    
    var targetPoint : CGPoint {
        let size = view.bounds.size
        return panState == .Closed ? CGPoint(x: size.width/2, y: size.height * 1.25) : CGPoint(x: size.width/2, y: size.height/2 + 200)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        draggableView = DraggableView(frame: CGRectZero)
        draggableView.layer.cornerRadius = 6
        
        view.addSubview(draggableView)
        
        draggableView.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(view)
            make.top.equalTo(view).offset(view.bounds.height * 0.75)
        }
        
        draggableView.backgroundColor = UIColor.cyanColor()
        draggableView.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPan(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func didPan(gesture : UITapGestureRecognizer){
        panState = panState == .Open ? .Closed : .Open
        guard let springAnimation = springAnimation else { return }
        startAnimatingView(draggableView, initialVelocity: springAnimation.velocity)
    }
    
    func startAnimatingView(view: DraggableView, initialVelocity: CGPoint) {
        cancelSpringAnimation()
        springAnimation = UINTSpringAnimation.animationWithView(view, target: targetPoint, velocity: initialVelocity)
        view.animator()?.addAnimation(springAnimation!)
    }
    
    private func cancelSpringAnimation() {
        if let springAnimation = springAnimation{
            view.animator()?.removeAnimation(springAnimation)
            self.springAnimation = nil
        }
    }
}

extension UINTViewController : DraggableViewDelegate {
    func draggableViewBeganDraggin(view: DraggableView) {
        cancelSpringAnimation()
    }
    
    func draggableView(view: DraggableView, draggingEndedWithVelocity velocity: CGPoint) {
        panState = velocity.y >= 0 ? .Closed : .Open
        startAnimatingView(view, initialVelocity: velocity)
    }
}
