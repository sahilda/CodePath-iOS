//
//  PhotoDetailsViewController.swift
//  InstaTumblr
//
//  Created by Joshua Escribano on 10/13/16.
//  Copyright © 2016 JoshuaSahil. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    var photoUrl: String = ""
    var caption: String = ""
    var postUrl: String = ""

    @IBOutlet weak var photoDetailsImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: photoUrl)
        self.photoDetailsImage.setImageWith(url!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
