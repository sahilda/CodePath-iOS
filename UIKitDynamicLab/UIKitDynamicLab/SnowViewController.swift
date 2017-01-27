//
//  SnowViewController.swift
//  UIKitDynamicLab
//
//  Created by Sahil Agarwal on 1/26/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

class SnowViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet var backgroundView: UIView!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        collision = UICollisionBehavior()
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        collision.collisionDelegate = self
        
        collision.addBoundary(withIdentifier: "shelf" as NSCopying, from: CGPoint(x: 0, y: 240), to: CGPoint(x: 210, y: 280))
        
        collision.addBoundary(withIdentifier: "bottom" as NSCopying, from: CGPoint(x: 0, y: 667), to: CGPoint(x: 375, y: 667))
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.createSnowParticle), userInfo: nil, repeats: true)
        
    }
    
    func createSnowParticle() {
        let x = CGFloat(arc4random_uniform(UInt32(backgroundView.frame.maxX)))
        let view = UIView(frame: CGRect(x: x, y: backgroundView.frame.minY, width: 5, height: 5))
        view.backgroundColor = UIColor.white
        backgroundView.addSubview(view)
        gravity.addItem(view)
        collision.addItem(view)
    }
    
    func meltSnow(snowView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            snowView.alpha = 0}, completion: { (true) -> Void in
                snowView.removeFromSuperview()})
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        // You have to convert the identifier to a string
        let boundary = identifier as! String
        
        // The view that collided with the boundary has to be converted to a view
        let view = item as! UIView
        
        if boundary == "shelf" {
            // Detected collision with a boundary called "shelf"
        } else if (boundary == "bottom") {
            // Detected collision with bounds of reference view
            meltSnow(snowView: view)
        }
    }
    

}
