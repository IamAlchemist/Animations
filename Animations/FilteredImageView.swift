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

class FilteredImageView : GLKView {
    
    var ciContext : CIContext!
    
    var filter : CIFilter? {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}

extension FilteredImageView : CIFilterParameterAdjustmentDelegate {
    func parameterValueDidChange(param: ScalarFilterParameter) {
        filter?.setValue(param.currentValue, forKeyPath: param.key)
        setNeedsDisplay()
    }
}

