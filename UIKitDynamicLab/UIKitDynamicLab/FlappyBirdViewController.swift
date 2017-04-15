//
//  FlappyBirdViewController.swift
//  UIKitDynamicLab
//
//  Created by Agarwal, Sahil on 4/12/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

class FlappyBirdViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var pipe1ImageView: UIImageView!
    @IBOutlet weak var pipe2ImageView: UIImageView!
    @IBOutlet weak var birdImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var push: UIPushBehavior!
    var collision: UICollisionBehavior!
    var birdItemBehavior: UIDynamicItemBehavior!
    var pipeItemBehavior: UIDynamicItemBehavior!
    
    var forwardVelocity:CGFloat = 0
    var pipeVelocity:CGFloat = -175
    var pipeHeight = 160
    var gravityVelocity:Double = 1.3
    var level:Int = 1
    var score = 0
    var pipeTimer:Double = 1.6
    var alive:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator()
        setupInitialBackgroundAndImages()
        setupInitialGravityBehavior()
        setupInitialPushBehavior()
        setupInitialCollisionBehavior()
        collision.collisionDelegate = self
        setupInitialBirdItemBehavior()
        setupInitialPipeItemBehavior()
        setupBoundaries()
        tapGesture(target: view)
        Timer.scheduledTimer(timeInterval: pipeTimer, target: self, selector: #selector(self.drawPipes), userInfo: nil, repeats: true)
    }
    
    func setupInitialBackgroundAndImages() {
        backgroundImageView.image = UIImage(named: "bg")
        birdImageView.image = UIImage(named: "bird")
        pipe1ImageView.image = UIImage(named: "pipeTop")
        pipe2ImageView.image = UIImage(named: "pipeBottom")
    }
    
    func setupInitialGravityBehavior() {
        gravity = UIGravityBehavior(items: [birdImageView])
        gravity.gravityDirection = CGVector(dx: 0.0, dy: gravityVelocity)
        animator.addBehavior(gravity)
    }
    
    func setupInitialPushBehavior() {
        push = UIPushBehavior(items: [birdImageView], mode: UIPushBehaviorMode.instantaneous)
        animator.addBehavior(push)
    }
    
    func setupInitialCollisionBehavior() {
        collision = UICollisionBehavior(items: [birdImageView, pipe1ImageView, pipe2ImageView])
        animator.addBehavior(collision)
    }
    
    func setupInitialBirdItemBehavior() {
        birdItemBehavior = UIDynamicItemBehavior(items: [birdImageView])
        birdItemBehavior.addLinearVelocity(CGPoint(x: forwardVelocity, y: 0), for: birdImageView)
        animator.addBehavior(birdItemBehavior)
    }
    
    func setupInitialPipeItemBehavior() {
        pipeItemBehavior = UIDynamicItemBehavior(items: [pipe1ImageView, pipe2ImageView])
        pipeItemBehavior.addLinearVelocity(CGPoint(x: pipeVelocity, y: 0), for: pipe1ImageView)
        pipeItemBehavior.addLinearVelocity(CGPoint(x: pipeVelocity, y: 0), for: pipe2ImageView)
        animator.addBehavior(pipeItemBehavior)
    }
    
    func setupBoundaries() {
        collision.addBoundary(withIdentifier: "bottom" as NSCopying, from: CGPoint(x: 0, y: view.frame.maxY + 50), to: CGPoint(x: view.frame.maxX, y: view.frame.maxY + 50))
        
        collision.addBoundary(withIdentifier: "leftSide" as NSCopying, from: CGPoint(x: -100, y: view.frame.minY), to: CGPoint(x: -100, y: view.frame.maxY))
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        birdItemBehavior.addLinearVelocity(CGPoint(x: -birdItemBehavior.linearVelocity(for: birdImageView).x, y: 0), for: birdImageView)
        if (birdItemBehavior.linearVelocity(for: birdImageView).y < 250) {
            push.pushDirection = CGVector(dx: 0, dy: -1.5)
        } else {
            push.pushDirection = CGVector(dx: 0, dy: -1.25 * gravity.magnitude)
        }
        birdItemBehavior.addLinearVelocity(CGPoint(x: forwardVelocity, y: -birdItemBehavior.linearVelocity(for: birdImageView).y), for: birdImageView)
        push.active = true
    }
    
    func tapGesture(target: UIView) {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTapGesture(sender:)))
        target.addGestureRecognizer(tapGesture)
    }
    
    func drawPipes() {
        if (alive) {
            makeTopAndBottomPipe()
            score += 1
            if (score % 5 == 0) {
                difficultSelector()
            }
        }
    }
    
    func difficultSelector() {
        level += 1
        pipeVelocity -= 25
    }
    
    func makePipe(bottomPipe: Bool) {
        var image = UIImage(named: "pipeTop")
        let x = Int(view.frame.maxX)
        var y = Int(view.frame.minY)
        let height = Int(arc4random_uniform(100) + UInt32(pipeHeight))
        
        if (bottomPipe) {
            image = UIImage(named: "pipeBottom")
            y = Int(view.frame.maxY) - height
        }
        
        let width = Int(Double((image?.cgImage?.width)!) * Double(arc4random_uniform(3) + 4) / 3)
        let cgRect = CGRect(x: x, y: y, width: width, height: height)
        let imageView = UIImageView(frame: cgRect)
        imageView.image = image
        collision.addItem(imageView)
        pipeItemBehavior.addItem(imageView)
        pipeItemBehavior.addLinearVelocity(CGPoint(x: pipeVelocity, y: 0), for: imageView)
        backgroundImageView.addSubview(imageView)
    }
    
    func makeTopPipe() {
        makePipe(bottomPipe: false)
    }
    
    func makeBottomPipe() {
        makePipe(bottomPipe: true)
    }
    
    func makeTopAndBottomPipe() {
        makeTopPipe()
        makeBottomPipe()
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        // You have to convert the identifier to a string
        let boundary = identifier as! String
        // The view that collided with the boundary has to be converted to a view
        let view = item as! UIView
        
        if boundary == "leftSide" {
            UIView.animate(withDuration: 0, animations: {() -> Void in}, completion: { (true) -> Void in
                self.collision.removeItem(view)
                view.removeFromSuperview()
                
            })
        } else if (boundary == "bottom") {
            endGame()
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        endGame()
    }
    
    func endGame() {
        alive = false
        self.dismiss(animated: true, completion: nil)
    }
    
}
