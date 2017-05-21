//
//  ViewController.swift
//  tinder_remade
//
//  Created by Sahil Agarwal on 11/10/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    @IBOutlet weak var draggableImageView: DraggableImageView!
    var imageViewCenterPoint: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        draggableImageView.image = UIImage(named: "ryan")
        draggableImageView.layoutIfNeeded()
        draggableImageView.layer.cornerRadius = 5
        draggableImageView.layer.masksToBounds = true
    }

    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: draggableImageView)
        
        if sender.state == .began {
            imageViewCenterPoint = draggableImageView.center
        } else if sender.state == .changed {
            let bottomHalfTouched : Bool = sender.location(in: draggableImageView).y > (draggableImageView.frame.size.height / 2)
            let rightHalfTouched : Bool = sender.location(in: draggableImageView).x > (draggableImageView.frame.size.width / 2)
            var radiansRotate = CGFloat()
            if (rightHalfTouched && bottomHalfTouched) {
                let x = min(translation.x, 180)
                radiansRotate = CGFloat(-x * .pi / 180)
            } else if (rightHalfTouched && !bottomHalfTouched) {
                let x = min(translation.x, 180)
                radiansRotate = CGFloat(x * .pi / 180)
            } else if (!rightHalfTouched && bottomHalfTouched) {
                let x = min(translation.x, 180)
                radiansRotate = CGFloat(-x * .pi / 180)
            } else if (!rightHalfTouched && !bottomHalfTouched) {
                let x = min(translation.x, 180)
                radiansRotate = CGFloat(x * .pi / 180)
            }
            draggableImageView.transform = CGAffineTransform(rotationAngle: radiansRotate)
            draggableImageView.center = CGPoint(x: imageViewCenterPoint.x + translation.x * 1.15, y: imageViewCenterPoint.y)
        } else if sender.state == .ended {
            if (translation.x > 50) {
                UIView.animate(withDuration: 0.2, animations: { void in
                    self.draggableImageView.center = CGPoint(x: self.imageViewCenterPoint.x + translation.x * 1.15 + 350, y: self.imageViewCenterPoint.y)
                }, completion: { finished in
                    self.draggableImageView?.removeFromSuperview()
                })
            } else if (translation.x < -50) {
                UIView.animate(withDuration: 0.2, animations: { void in
                    self.draggableImageView.center = CGPoint(x: self.imageViewCenterPoint.x + translation.x * 1.15 - 350, y: self.imageViewCenterPoint.y)
                }, completion: { finished in
                    self.draggableImageView?.removeFromSuperview()
                })
            } else {
                draggableImageView.center = imageViewCenterPoint
                draggableImageView.transform = .identity
            }
        }
    }

    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "profileModal", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileModal" {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.profileImage = draggableImageView!.image!
        }
    }
    
}

