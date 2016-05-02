//
//  ContainerViewController.swift
//  DemoAnimations
//
//  Created by wizard on 5/2/16.
//  Copyright © 2016 Alchemist. All rights reserved.
//

import UIKit
import SnapKit

class ContainerViewController : UIViewController {
    var viewControllers : [UIViewController]

    private var _selectedViewController : UIViewController? = nil
    private(set) var selectedViewController : UIViewController? {
        set {
            precondition(newValue != nil, "selected view controller can't be empty")
            transitionToChildViewController(newValue)
            _selectedViewController = newValue
            updateButtonSelection()
        }
        
        get {
            return _selectedViewController
        }
    }
    
    init(viewControllers : [UIViewController]) {
        precondition(viewControllers.count > 1, "must have more than one view controllers")
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewControllers = []
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedViewController = selectedViewController ?? viewControllers[0]
    }
    
    override func loadView() {
        
        func addChildViewControllerButtons() {
            for (index, viewController) in viewControllers.enumerate() {
                let button = UIButton(type: .Custom)
                let icon = viewController.tabBarItem.image?.imageWithRenderingMode(.AlwaysTemplate)
                button.setImage(icon, forState: .Normal)
                
                let selectedIcon = viewController.tabBarItem.selectedImage?.imageWithRenderingMode(.AlwaysTemplate)
                button.setImage(selectedIcon, forState: .Selected)
                
                button.tag = index
                
                button.addTarget(self,
                                 action: #selector(buttonTapped(_:)),
                                 forControlEvents: .TouchUpInside)
                
                guard let buttonView = buttonView else { break }
                buttonView.addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false
                
                button.snp_makeConstraints(closure: { (make) in
                    make.centerX.equalTo(buttonView.snp_leading).offset((CGFloat(index) + 0.5) * 64)
                    make.centerY.equalTo(buttonView)
                })
            }
        }
        
        let rootView = UIView()
        rootView.backgroundColor = UIColor.blackColor()
        rootView.opaque = true
        
        containerView = UIView()
        containerView?.backgroundColor = UIColor.blackColor()
        containerView?.opaque = true
        
        buttonView = UIView()
        buttonView?.backgroundColor = UIColor.clearColor()
        buttonView?.tintColor = UIColor(white: 1, alpha: 0.75)
        
        containerView?.translatesAutoresizingMaskIntoConstraints = false
        buttonView?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let containerView = containerView,
            let buttonView = buttonView
            else { return }
        rootView.addSubview(containerView)
        rootView.addSubview(buttonView)
        
        containerView.snp_makeConstraints { (make) in
            make.top.equalTo(rootView)
            make.left.equalTo(rootView)
            make.right.equalTo(rootView)
            make.bottom.equalTo(rootView)
        }
        
        buttonView.snp_makeConstraints { (make) in
            make.width.equalTo(viewControllers.count * 64)
            make.centerX.equalTo(containerView)
            make.height.equalTo(44)
            make.centerY.equalTo(containerView).multipliedBy(0.4)
        }
        
        addChildViewControllerButtons()
        
        view = rootView
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return selectedViewController
    }
    
    func buttonTapped(button: UIButton) {
        if button.tag < viewControllers.count {
            selectedViewController = viewControllers[button.tag]
        }
    }
    
    private var containerView : UIView?
    private var buttonView : UIView?
    
    private func updateButtonSelection() {
        guard let buttonView = buttonView,
            let buttons = (buttonView.subviews as? [UIButton])
            else { return }
        
        for (index, button) in buttons.enumerate() {
            button.selected = (viewControllers[index] == selectedViewController)
        }
    }
    
    private func transitionToChildViewController(toViewController : UIViewController?) {
        
        let fromViewController : UIViewController? = childViewControllers.count > 0 ? childViewControllers[0] : nil
        
        if toViewController == fromViewController
            || !isViewLoaded() {
            return
        }
        
        guard let toViewController = toViewController,
            let containerView = containerView
            else { return }
        
        let toView = toViewController.view
        toView.translatesAutoresizingMaskIntoConstraints = true
        toView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        toView.frame = containerView.bounds
        
        fromViewController?.willMoveToParentViewController(nil)
        addChildViewController(toViewController)
        
        guard let _fromViewController = fromViewController else {
            containerView.addSubview(toView)
            toViewController.didMoveToParentViewController(self)
            return
        }
        
        let animator = FadeAndScaleTransitioningPop()
        
        guard let fromIndex = viewControllers.indexOf(_fromViewController),
            let toIndex = viewControllers.indexOf(toViewController)
            else { return }
        
        guard let transitionContext = PrivateTransitionContext(
            fromViewController: _fromViewController,
            toViewController: toViewController,
            goingRight: toIndex > fromIndex)
            else { return }
        
        transitionContext.animated = true
        transitionContext.interactive = false
        transitionContext.completionBlock = { didComplete in
            _fromViewController.view.removeFromSuperview()
            _fromViewController.removeFromParentViewController()
            toViewController.didMoveToParentViewController(self)
            
            if animator.respondsToSelector(#selector(UIViewControllerAnimatedTransitioning.animationEnded(_:))) {
                (animator as UIViewControllerAnimatedTransitioning).animationEnded?(didComplete)
            }
            
            self.buttonView?.userInteractionEnabled = true
        }
        
        buttonView?.userInteractionEnabled = false
        
        animator.animateTransition(transitionContext)
    }
}
