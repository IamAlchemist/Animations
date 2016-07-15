//
//  TransitionDemoViewController.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/15/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class TransitionDemoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(TransitionDemoViewController.dismiss))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func switchImage(sender: UIButton) {
        let images = [UIImage(named:"Anchor"), UIImage(named:"Cone"), UIImage(named:"IgIoo"), UIImage(named:"Spaceship")]
        
        UIView.transitionWithView(imageView, duration: 1.0,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations: {
                                    self.imageView.image = images[self.index % images.count]
                                    self.index += 1
                                  },
                                  completion: nil)
    }
    
    @IBAction func performTransition(sender: UIButton) {
        var coverImage : UIImage? = nil;
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
        if let currentContext = UIGraphicsGetCurrentContext() {
            view.layer.renderInContext(currentContext)
            coverImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        let coverView = UIImageView(image: coverImage)
        
        coverView.frame = view.bounds
        
        view.addSubview(coverView)
        
        let red = CGFloat(arc4random()) / CGFloat(INT_MAX)
        let green = CGFloat(arc4random()) / CGFloat(INT_MAX)
        let blue = CGFloat(arc4random()) / CGFloat(INT_MAX)
        
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
        UIView.animateWithDuration(1.0, animations: {
            var transform = CGAffineTransformMakeScale(0.01, 0.01)
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
                coverView.transform = transform
                coverView.alpha = 0.0
            },
            completion: { _ in
                coverView.removeFromSuperview()
        })
    }
}

