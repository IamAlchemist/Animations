//
//  PullToRefreshViewController.swift
//  DemoAnimations
//
//  Created by wizard lee on 7/17/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
import SnapKit

class PullToRefreshViewController: UICollectionViewController {
    
    var isLoading = false
    
    var primes = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = false
        
        setupLoadingIndicator()
    }
    
    var loadingIndicator : UIView!
    lazy var textShapeLayer : CAShapeLayer = {
        let letters = CGPathCreateMutable()
        
        let font = CTFontCreateWithName("Helvetica" as NSString, 50, nil)
        let attrs = [NSFontAttributeName : font]
        let attrString = NSAttributedString(string: "Loading", attributes: attrs)
        
        let line = CTLineCreateWithAttributedString(attrString)
        let runArray = ((CTLineGetGlyphRuns(line) as [AnyObject]) as! [CTRunRef])
        
        for index in 0..<CFArrayGetCount(runArray)
        {
            let run = runArray[index]
            
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run)
            {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph = CGGlyph()
                var position = CGPoint()
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &position)
                
                let letter = CTFontCreatePathForGlyph(font, glyph, nil)
                var t = CGAffineTransformMakeTranslation(position.x, position.y);
                
                CGPathAddPath(letters, &t, letter)
            }
        }
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.appendPath(UIBezierPath(CGPath: letters))
        
        let pathLayer = CAShapeLayer()
        pathLayer.bounds = CGPathGetBoundingBox(path.CGPath)
        pathLayer.geometryFlipped = true
        pathLayer.path = path.CGPath
        pathLayer.strokeColor = UIColor.blackColor().CGColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineJoin = kCALineJoinBevel
        
        return pathLayer
    }()
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIView(frame: CGRect(x: 0, y: -45, width: 230, height: 70))
        
        collectionView?.addSubview(loadingIndicator)
        
        loadingIndicator.snp_makeConstraints { (make) in
            make.width.equalTo(230)
            make.height.equalTo(70)
            make.centerX.equalTo(collectionView!)
            make.top.equalTo(collectionView!).offset(-70)
        }
        
        textShapeLayer.frame = loadingIndicator.bounds
        textShapeLayer.speed = 0
        textShapeLayer.strokeEnd = 0
        
        loadingIndicator.layer.addSublayer(textShapeLayer)
        
        let writeText = CABasicAnimation(keyPath: "strokeEnd")
        writeText.fromValue = NSNumber(float:0)
        writeText.toValue = NSNumber(float:1)
        writeText.fillMode = kCAFillModeForwards
//        writeText.removedOnCompletion = false
        
        textShapeLayer.addAnimation(writeText, forKey: nil)
    }
}

extension PullToRefreshViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return primes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PullToRefreshCell", forIndexPath: indexPath) as! PullToRefreshCell
        
        cell.label.text = "\(primes[indexPath.row])"
        
        return cell
    }
}

extension PullToRefreshViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        
        if offset <= 0 && !isLoading && isViewLoaded() {
            let threshold : CGFloat = 300
            let fraction = -offset/threshold
            
            textShapeLayer.timeOffset = min(1.0, Double(fraction))
            
            print("time off set : \(textShapeLayer.timeOffset)")
            
            if (fraction >= 1.0) {
//                startLoading()
            }
        }
    }
}








































