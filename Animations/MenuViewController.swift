//
//  ViewController.swift
//  Animations
//
//  Created by wizard on 1/18/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    let dataSource = MenuDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }
    
}

extension MenuViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(targetSegueAtIndexPath(indexPath), sender: self)
    }
    
    func targetSegueAtIndexPath(indexPath : NSIndexPath) -> String {
        return dataSource.titles[indexPath.row] + "Segue"
    }
}

class MenuTableViewCell : UITableViewCell {
    func configWithTitle(title: String) {
        textLabel?.text = title
    }
}

class MenuDataSource : NSObject, UITableViewDataSource {
    let titles = ["CustomShow",
                  "InteractivePush",
                  "DissolvedShow",
                  "ShowClockFace",
                  "ShowClockFace2",
                  "ShowClockFace3",
                  "ShowGroupAnim",
                  "ShowBezierPath",
                  "ShowCustomContainer"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableViewCell
        cell.configWithTitle(titles[indexPath.item])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
}



