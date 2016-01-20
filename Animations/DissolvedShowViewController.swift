//
//  DissolvedShowViewController.swift
//  Animations
//
//  Created by Wizard Li on 1/20/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class DissolvedShowViewController : UIViewController {
    
    @IBAction func quit(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

