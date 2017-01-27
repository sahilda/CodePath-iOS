//
//  ViewController.swift
//  UIKitDynamicLab
//
//  Created by Sahil Agarwal on 1/26/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blockView: UIView!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var startLocation: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        collision = UICollisionBehavior()
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        startLocation = blockView.frame.origin
    }

    @IBAction func onBlockTap(_ sender: UITapGestureRecognizer) {
        gravity.addItem(blockView)
        collision.addItem(blockView)
        collision.translatesReferenceBoundsIntoBoundary = true
    }

    @IBAction func onResetButton(_ sender: Any) {
        gravity.removeItem(blockView)
        collision.removeItem(blockView)
        blockView.frame.origin = startLocation
    }
    
}

