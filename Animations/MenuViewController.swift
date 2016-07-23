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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "ShowCustomContainerSegue":
            guard let contianerViewController = (segue.destinationViewController as? ContainerViewController) else { break }
            contianerViewController.viewControllers = generateChildViewControllers()
        default:
            break
        }
    }
    
    private func generateChildViewControllers() -> [UIViewController] {
        var childViewControllers = [UIViewController]()
        let color1 = UIColor(red: 0.4, green: 0.8, blue: 1, alpha: 1)
        let color2 = UIColor(red: 1, green: 0.4, blue: 0.8, alpha: 1)
        let color3 = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1)
        
        let first = ["title" : "First", "color" : color1]
        let second = ["title" : "Second", "color" : color2]
        let third = ["title" : "Third", "color" : color3]
        
        let configs = [first, second, third]
        
        for config in configs {
            let childViewController = ChildViewController()
            let title = config["title"] as? String
            let color = config["color"] as? UIColor
            childViewController.title = title
            childViewController.themeColor = color
            childViewController.tabBarItem.image = UIImage(named: title)
            childViewController.tabBarItem.selectedImage = UIImage(named: title == nil ? nil : title! + "_selected")
            
            childViewControllers.append(childViewController)
        }
        
        return childViewControllers
    }
}

extension UIImage {
    convenience init?(named name : String?){
        if let name = name {
            self.init(named: name)
        }
        else {
            return nil
        }
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
                  "ShowCustomContainer",
                  "ShowInteractiveUIDynamic",
                  "ShowCustomIA",
                  "ShowLayerAnimation",
                  "PresentTransition",
                  "OpenDoor",
                  "BouncingBall",
                  "PullToRefresh",
                  "KeyFrameEasing",
                  "Chalkboard",
                  "ImageCache"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableViewCell
        cell.configWithTitle(titles[indexPath.item])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
}



