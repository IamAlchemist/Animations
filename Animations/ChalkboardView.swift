//
//  ChalkboardView.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/18/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class ChalkboardView: UIView {
    var strokes = [CGPoint]()
    
    let brushSize: CGFloat = 32
    
    override func awakeFromNib() {
        layer.drawsAsynchronously = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.drawsAsynchronously = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.drawsAsynchronously = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        let position = touch.locationInView(self)
        addBrushStrokeAtPoint(position)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        addBrushStrokeAtPoint(touch.locationInView(self))
    }
    
    override func drawRect(rect: CGRect) {
        for stroke in strokes {
            let brushRect = brushRectForPoint(stroke)
            if CGRectIntersectsRect(rect, brushRect) {
                UIImage(named: "Chalk")?.drawInRect(brushRect)
            }
        }
    }
    
    private func addBrushStrokeAtPoint(point: CGPoint) {
        strokes.append(point)
        setNeedsDisplayInRect(brushRectForPoint(point))
    }
    
    private func brushRectForPoint(point: CGPoint) -> CGRect {
        return CGRect(x: point.x - brushSize,
                      y: point.y - brushSize,
                      width: brushSize,
                      height: brushSize)
    }
}
