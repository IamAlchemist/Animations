//
//  FilteredImageView.swift
//  Animations
//
//  Created by Wizard Li on 1/20/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
import GLKit
import CoreImage

struct ScalarFilterParameter
{
    var name: String?
    var key: String
    var minimumValue: Float?
    var maximumValue: Float?
    var currentValue: Float
    
    init(key: String, value: Float) {
        self.key = key
        self.currentValue = value
    }
    
    init(name: String, key: String, minimumValue: Float, maximumValue: Float, currentValue: Float)
    {
        self.name = name
        self.key = key
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.currentValue = currentValue
    }
}

protocol CIFilterParameterAdjustmentDelegate {
    func parameterValueDidChange(param: ScalarFilterParameter)
}

typealias Filter = CIImage -> CIImage

class CompositedFilter {
    var filters = [Filter]()
    func drawOutputInContext(cicontext : CIContext){}
}

class FilteredImageView : GLKView {
    
    var ciContext : CIContext!
    
    var filter : CIFilter? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var filter2 : CIFilter? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var inputImage : UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame, context: EAGLContext(API: .OpenGLES2))
        ciContext = CIContext(EAGLContext: context)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        context = EAGLContext(API: .OpenGLES2)
        ciContext = CIContext(EAGLContext: context)
    }
    
    override func drawRect(rect: CGRect) {
        if let inputImage = self.inputImage, filter = self.filter where ciContext != nil {
            let inputCIImage = CIImage(image: inputImage)
            filter.setValue(inputCIImage, forKeyPath: kCIInputImageKey)
            if let outputImage = filter.outputImage {
                clearBackground()
                
                let inputBounds = inputCIImage!.extent
                let drawableBounds = CGRect(x: 0, y: 0, width: drawableWidth, height: drawableHeight)
                let targetBounds = imageBoundsForContentMode(inputBounds, toRect: drawableBounds)
                ciContext.drawImage(outputImage, inRect: targetBounds, fromRect: inputBounds)
            }
            
            if let filter2 = self.filter2 {
                filter2.setValue(inputCIImage, forKey: kCIInputImageKey)
                if let outputImage = filter2.outputImage {
                    let inputBounds = inputCIImage!.extent
                    let drawableBounds = CGRect(x: 0, y: 0, width: drawableWidth, height: drawableHeight)
                    let targetBounds = imageBoundsForContentMode(inputBounds, toRect: drawableBounds)
                    ciContext.drawImage(outputImage, inRect: targetBounds, fromRect: inputBounds)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    // MARK: -  helper
    func clearBackground() {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        glClearColor(GLfloat(r), GLfloat(g), GLfloat(b), GLfloat(a))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }
    
    func imageBoundsForContentMode(fromRect: CGRect, toRect: CGRect) -> CGRect {
        switch contentMode {
        case .ScaleAspectFill:
            return aspectFill(fromRect, toRect: toRect)
        case .ScaleAspectFit:
            return aspectFit(fromRect, toRect: toRect)
        default:
            return fromRect
        }
    }
    
    func aspectFit(fromRect: CGRect, toRect: CGRect) -> CGRect {
        let fromAspectRatio = fromRect.size.width / fromRect.size.height;
        let toAspectRatio = toRect.size.width / toRect.size.height;
        
        var fitRect = toRect
        
        if (fromAspectRatio > toAspectRatio) {
            fitRect.size.height = toRect.size.width / fromAspectRatio;
            fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
        } else {
            fitRect.size.width = toRect.size.height  * fromAspectRatio;
            fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
        }
        
        return CGRectIntegral(fitRect)
    }
    
    func aspectFill(fromRect: CGRect, toRect: CGRect) -> CGRect {
        let fromAspectRatio = fromRect.size.width / fromRect.size.height;
        let toAspectRatio = toRect.size.width / toRect.size.height;
        
        var fitRect = toRect
        
        if (fromAspectRatio > toAspectRatio) {
            fitRect.size.width = toRect.size.height  * fromAspectRatio;
            fitRect.origin.x += (toRect.size.width - fitRect.size.width) * 0.5;
        } else {
            fitRect.size.height = toRect.size.width / fromAspectRatio;
            fitRect.origin.y += (toRect.size.height - fitRect.size.height) * 0.5;
        }
        
        return CGRectIntegral(fitRect)
    }
}

extension FilteredImageView : CIFilterParameterAdjustmentDelegate {
    func parameterValueDidChange(param: ScalarFilterParameter) {
        filter?.setValue(param.currentValue, forKeyPath: param.key)
        setNeedsDisplay()
    }
}

