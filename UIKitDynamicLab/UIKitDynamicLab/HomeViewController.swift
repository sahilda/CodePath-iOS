//
//  HomeViewController.swift
//  UIKitDynamicLab
//
//  Created by Sahil Agarwal on 1/26/17.
//  Copyright © 2017 Sahil Agarwal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBlockDemoButton(_ sender: Any) {
        performSegue(withIdentifier: "block", sender: nil)
    }

    @IBAction func onSnowParticleButton(_ sender: Any) {
        performSegue(withIdentifier: "snow", sender: nil)
    }

}
