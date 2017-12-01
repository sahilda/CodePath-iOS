//
//  HamburgerViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/5/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    var originalLeftMarginConstraint: CGFloat!
    var menuOpen = false
    let maxSize: CGFloat = 125
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: ({
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }))
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMarginConstraint = leftMarginConstraint.constant
        
        } else if sender.state == .changed {
            let maxTranslationX = self.view.frame.size.width - maxSize - leftMarginConstraint.constant
            if ((leftMarginConstraint.constant + translation.x) < 0) {
                leftMarginConstraint.constant = 0
            } else if (translation.x > maxTranslationX) {
                leftMarginConstraint.constant = self.view.frame.size.width - maxSize
            } else {
                leftMarginConstraint.constant = originalLeftMarginConstraint + translation.x
            }
            
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: ({
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width - self.maxSize
                    self.menuOpen = true
                } else {
                    self.leftMarginConstraint.constant = 0
                    self.menuOpen = false
                }
                self.view.layoutIfNeeded()                
            }))
        }
        
    }

}
