//
//  ClockFace2ViewController.swift
//  Animations
//
//  Created by wizard on 2/10/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class ClockFace2ViewController : UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hourTextField: UITextField!
    
    var clockface : ClockFace2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourTextField.delegate = self
        
        clockface = ClockFace2()
        clockface.position = CGPoint(x: view.bounds.width / 2 , y: 180)
        view.layer.addSublayer(clockface)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        clockface.time = (textField.text! as NSString).floatValue
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
