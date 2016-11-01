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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imageView.image = UIImage(named: "background")
        twitterLogo.image = UIImage(named: "twitter_white_logo")
        loginButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.login(success: { () -> () in
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }, failure: { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        })
    }

}

