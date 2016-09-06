//
//  SettingsViewController.swift
//  goodtips
//
//  Created by Sahil Agarwal on 9/4/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipSelectedSegmentIndex = defaults.integerForKey("tipSelectedSegmentIndex")
        tipControl.selectedSegmentIndex = tipSelectedSegmentIndex
    }
    
    @IBAction func saveIndex(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipSelectedSegmentIndex")
        defaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

}
