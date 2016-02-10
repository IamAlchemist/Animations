//
//  ClockFaceViewController.swift
//  Animations
//
//  Created by wizard on 2/7/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class ClockFaceViewController : UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var clockFace : ClockFace!
    
    @IBAction func updateTime(sender: UIButton) {
        clockFace.time = datePicker.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockFace = ClockFace()
        clockFace.position = CGPoint(x: view.bounds.width / 2, y: 200)
        view.layer.addSublayer(clockFace)
    }
}
