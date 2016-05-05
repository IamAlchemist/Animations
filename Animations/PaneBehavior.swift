//
//  PaneBehavior.swift
//  DemoAnimations
//
//  Created by wizard on 5/5/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class PaneBehavior : UIDynamicBehavior {
    var targetPoint : CGPoint? {
        didSet {
            guard let targetPoint = targetPoint else { return }
            attachmentBehavior?.anchorPoint = targetPoint
        }
    }
    
    var velocity : CGPoint? {
        didSet {
            guard let itemBehavior = itemBehavior,
                let velocity = velocity
                else { return }
            
            let currentVelocity = itemBehavior.linearVelocityForItem(item)
            let velocityDelta = CGPoint(x: velocity.x - currentVelocity.x, y: velocity.y - currentVelocity.y)
            itemBehavior.addLinearVelocity(velocityDelta, forItem: item)
        }
    }
    
    let item : UIDynamicItem
    
    var attachmentBehavior : UIAttachmentBehavior?
    var itemBehavior : UIDynamicItemBehavior?
    
    init(item: UIDynamicItem) {
        self.item = item
        super.init()
        setup()
    }
    
    func setup() {
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: CGPointZero)
        attachmentBehavior.frequency = 3.5
        attachmentBehavior.damping = 0.4
        attachmentBehavior.length = 0
        self.attachmentBehavior = attachmentBehavior
        
        addChildBehavior(attachmentBehavior)
        
        let itemBehavivor = UIDynamicItemBehavior(items: [item])
        itemBehavivor.density = 100
        itemBehavivor.resistance = 10
        self.itemBehavior = itemBehavivor
        
        addChildBehavior(itemBehavivor)
    }
}

