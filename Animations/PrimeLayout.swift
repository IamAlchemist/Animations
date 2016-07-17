//
//  PrimeLayout.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/17/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class PrimeLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        var transform = CATransform3DIdentity
        transform.m34 = -1/8.00
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), -1, 0, 0)
        transform = CATransform3DScale(transform, 0.8, 0.8, 0.8)
        attributes?.transform3D = transform
        
        return attributes
    }
}
