//
//  ProfileViewController.swift
//  tinder_remade
//
//  Created by Agarwal, Sahil on 5/21/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var nav_bar2: UIImageView!
    var profileImage: UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profile_image.image = profileImage
    }

    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}
