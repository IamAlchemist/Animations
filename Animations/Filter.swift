//
//  Filter.swift
//  Animations
//
//  Created by wizard on 1/21/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//  
//  we want to use it like this:
//  let myFilter : CIImage -> CIImage = blur(blurRadius) >|> colorOverlay(overlayColor)
//  let result = myFilter(image)
//  
//  furthermore:
//  let myCompositeFilter : [Image] -> CIImage = composite(filter1, filter2)
//  let result = myCompositeFilter([images])

import UIKit

typealias ImageFilter = [CIImage] -> CIImage

func pixellateImageFilter1D(scale : Float) -> ImageFilter {
    return { images in
        let params = [kCIInputScaleKey: scale, kCIInputImageKey: images[0]]
        let filter = CIFilter(name: "CIPixellate", withInputParameters: params)!
        return filter.outputImage!
    }
}

func whiteImageFilter1D() -> ImageFilter {
    return { images in
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
        let whiteVector = CIVector(x: 1, y: 1, z: 1, w: 1)
        let params = [kCIInputImageKey: images[0],
            "inputRVector" : zeroVector,
            "inputGVector" : zeroVector,
            "inputBVector" : zeroVector,
            "inputAVector" : zeroVector,
            "inputBiasVector": whiteVector]
        let filter = CIFilter(name: "CIColorMatrix", withInputParameters: params)!
        return filter.outputImage!
    }
}

func alphaImageFilter1D(alpha : Float) -> ImageFilter {
    var normalAlpha = min(alpha, 1)
    normalAlpha = max(normalAlpha, 0)

    return { images in
        let zeroVector = CIVector(x: 0, y: 0, z: 0, w: 0)
        let ciVector = CIVector(x: 1, y: 0, z: 0, w: CGFloat(normalAlpha))
        let params = [kCIInputImageKey: images[0],
            "inputRVector" : zeroVector,
            "inputGVector" : zeroVector,
            "inputBVector" : zeroVector,
            "inputAVector" : zeroVector,
            "inputBiasVector": ciVector]
        let filter = CIFilter(name: "CIColorMatrix", withInputParameters: params)!
        return filter.outputImage!
    }
}

func blendWithAlphaMaskImageFilter3D(backgroundFilter : ImageFilter, inputFilter : ImageFilter, alphaFilter : ImageFilter) -> ImageFilter {
    return { images in
        let backgroundImage = backgroundFilter([images[0]])
        let inputImage = inputFilter([images[1]])
        let maskImage = alphaFilter([images[2]])
        let params = [kCIInputImageKey: inputImage,
            kCIInputBackgroundImageKey: backgroundImage,
            kCIInputMaskImageKey: maskImage]
        let filter = CIFilter(name: "CIBlendWithAlphaMask", withInputParameters: params)!
        return filter.outputImage!
    }
}
func sourceOverCompositeImageFilter2D(filter1 : ImageFilter, filter2 : ImageFilter) -> ImageFilter {
    return { images in
        let imageOutput1 = filter1([images[0]])
        let imageOutput2 = filter2([images[1]])
        let params = [kCIInputImageKey: imageOutput1, kCIInputBackgroundImageKey: imageOutput2]
        let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: params)!
        return filter.outputImage!
    }
}

infix operator |> { associativity left }

func |> (filter1: ImageFilter, filter2: ImageFilter) -> ImageFilter {
    return { imgs in filter2([filter1(imgs)]) }
}


