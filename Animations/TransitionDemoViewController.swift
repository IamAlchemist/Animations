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
}

