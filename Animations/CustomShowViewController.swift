//
//  CustomShowViewController.swift
//  Animations
//
//  Created by Wizard Li on 1/19/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class CustomShowViewController : UIViewController {
    @IBAction func quit(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
