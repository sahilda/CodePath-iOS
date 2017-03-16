//
//  SpaceShipsViewController.swift
//  UIKitDynamicLab
//
//  Created by Sahil Agarwal on 1/29/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

class SpaceShipsViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var push: UIPushBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator()
        gravity = UIGravityBehavior()
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.3)
        collision = UICollisionBehavior()
        collision.collisionDelegate = self
        
        animator.addBehavior(collision)
        animator.addBehavior(gravity)
        
        tapGesture(target: backgroundView)
        Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.addSpaceship), userInfo: nil, repeats: true)
    }
    
    func addSpaceship() {
        let image = UIImage(named: "spaceship")
        let x = Int(arc4random_uniform(UInt32(backgroundView.frame.maxX)))
        let cgRect = CGRect(x: x, y: Int(backgroundView.frame.minY) - (image?.cgImage?.height)!, width: (image?.cgImage?.width)!, height: (image?.cgImage?.height)!)
        let imageView = UIImageView(frame: cgRect)
        imageView.image = image
        gravity.addItem(imageView)
        collision.addItem(imageView)
        backgroundView.addSubview(imageView)
    }

    func handleTapGesture(sender: UITapGestureRecognizer) {
        let block = UIView(frame: CGRect(x: sender.location(in: backgroundView).x, y: sender.location(in: backgroundView).y, width: 5, height: 5))
        block.backgroundColor = UIColor.black
        collision.addItem(block)
        backgroundView.addSubview(block)
        
        push = UIPushBehavior(items: [block], mode: UIPushBehaviorMode.continuous)
        push.pushDirection = CGVector(dx: 0, dy: -0.4)
        animator.addBehavior(push)
    }
    
    func tapGesture(target: UIView) {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTapGesture(sender:)))
        target.addGestureRecognizer(tapGesture)
    }

}

extension SpaceShipsViewController: UICollisionBehaviorDelegate {
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        let view1 = item1 as! UIView
        let view2 = item2 as! UIView
        view1.removeFromSuperview()
        view2.removeFromSuperview()
        
        let flash = UIImage(named: "flash")
        let cgRect = CGRect(x: p.x, y: p.y, width: CGFloat((flash?.cgImage?.width)!), height: CGFloat((flash?.cgImage?.width)!))
        let imageView = UIImageView(frame: cgRect)
        imageView.image = flash
        backgroundView.addSubview(imageView)
    
        UIView.animate(withDuration: 0.5, animations:
            { imageView.alpha = 0 }, completion: { finished in
            imageView.removeFromSuperview()}
        )
            
    }
    
}
