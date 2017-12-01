//
//  LoginViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/28/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class LoginViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var twitterLogo: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageView.image = UIImage(named: "background")
        twitterLogo.image = UIImage(named: "twitter_white_logo")
        loginButton.layer.cornerRadius = 6
        animateBackground()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.animateBackground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func animateBackground() {
        UIView.animate(withDuration: 12.0, delay:0, options: [.repeat, .autoreverse], animations: {
            self.imageView.transform = CGAffineTransform(scaleX: 3,y: 3)
        }, completion: nil)
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.login(success: { () -> () in
        
            let hamburgerViewController = HamburgerMenuLoader.loadHamburgetMenu()
            UIView.animate(withDuration: 1.5, animations: ({
                self.twitterLogo.transform = CGAffineTransform(scaleX: 25,y: 25)
            }), completion: ({ finish in
                self.present(hamburgerViewController, animated: true)
            }))
            
            
        }, failure: { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        })        
    }

}

