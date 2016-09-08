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
    @IBOutlet weak var tipPicker: UIPickerView!
    @IBOutlet weak var customTip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipSelectedSegmentIndex = defaults.integerForKey("tipSelectedSegmentIndex")
        tipControl.selectedSegmentIndex = tipSelectedSegmentIndex
        
        customTip.text = String(defaults.integerForKey("customTip"))
        let customTipLabel = customTip.text! + "%"
        tipControl.setTitle(customTipLabel, forSegmentAtIndex: 3)
    }
    
    @IBAction func saveIndex(sender: UISegmentedControl) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipSelectedSegmentIndex")
        defaults.synchronize()
    }
    
    @IBAction func saveCustomTipAndUpdateLabel(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let customTipPercent = customTip.text! == "" ? "0" : customTip.text!
        defaults.setInteger(Int(customTipPercent)!, forKey: "customTip")
        defaults.synchronize()
        
        let customTipLabel = customTipPercent + "%"
        tipControl.setTitle(customTipLabel, forSegmentAtIndex: 3)
    }
    
    @IBAction func clearField(sender: AnyObject) {
        customTip.text! = ""
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    

}
