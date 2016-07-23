//
//  CacheImageViewController.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/23/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit

class CacheImageViewController: UIViewController {
    
    private var imagePaths : [String]!
    private var cache : NSCache = NSCache()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePaths = NSBundle.mainBundle().pathsForResourcesOfType("png", inDirectory: "Vacation Photos")
        
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.dataSource = self
    }
    
    func loadImageAtIndex(index : Int) -> UIImage? {
        let object = cache.objectForKey(NSNumber(integer: index))
        
        if let _ = object as? NSNull {
            return nil
        }
            
        if let image = object as? UIImage {
            return image
        }

        cache.setObject(NSNull(), forKey: NSNumber(integer: index))
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) { 
            guard let imageBeforeExtract = UIImage(contentsOfFile: self.imagePaths[index]) else { return }
            
            UIGraphicsBeginImageContextWithOptions(imageBeforeExtract.size, true, 0)
            imageBeforeExtract.drawAtPoint(CGPointZero)
            let imageAfterExtract = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.cache.setObject(imageAfterExtract, forKey: NSNumber(integer: index))
                
                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                
                let cell = self.collectionView.cellForItemAtIndexPath(indexPath)
                
                let imageView = cell?.contentView.subviews.last as? UIImageView
                imageView?.image = imageAfterExtract
            })
        }
        
        return nil;
    }
}

extension CacheImageViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePaths.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        var imageView = cell.viewWithTag(99) as? UIImageView
        if (imageView == nil) {
            imageView = UIImageView(frame: cell.contentView.bounds)
            imageView!.tag = 99
            cell.contentView.addSubview(imageView!)
        }
        
        imageView?.image = loadImageAtIndex(indexPath.item)
        
        if indexPath.item < imagePaths.count - 1 {
            loadImageAtIndex(indexPath.item + 1)
        }
        if indexPath.item > 0 {
            loadImageAtIndex(indexPath.item - 1)
        }
        
        return cell
    }
}
