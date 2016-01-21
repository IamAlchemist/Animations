//
//  DissolvedShowViewController.swift
//  Animations
//
//  Created by Wizard Li on 1/20/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class DissolvedShowViewController : UIViewController {
    
    @IBOutlet weak var dissolvedImageView: FilteredImageView!
    
    @IBAction func quit(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var displayLink : CADisplayLink?
    
    var pixelScale : Float = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dissolvedImageView.contentMode = .ScaleAspectFit
        dissolvedImageView.inputImage = UIImage(named: "john-paulson")
        dissolvedImageView.filter = CIFilter(name: "CIPixellate")
        
        displayLink = CADisplayLink(target: self, selector: "update:")
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink?.paused = true
    }
    
    func update(displayLink : CADisplayLink) {
        print("update : \(pixelScale)")
        pixelScale += 2
        pixelScale = pixelScale > 100 ? 2 : pixelScale;
        let param = ScalarFilterParameter(key: "inputScale", value: pixelScale)
        dissolvedImageView.parameterValueDidChange(param)
    }
}

