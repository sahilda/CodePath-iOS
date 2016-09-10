//
//  SettingsViewController.swift
//  goodtips
//
//  Created by Sahil Agarwal on 9/4/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipText: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var modeText: UILabel!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var customTipText: UILabel!
    @IBOutlet weak var customTip: UITextField!
    @IBOutlet weak var percentSignText: UILabel!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tipSelectedSegmentIndex = defaults.integerForKey("tipSelectedSegmentIndex")
        tipControl.selectedSegmentIndex = tipSelectedSegmentIndex
        
        // set colors and mode switch
        let mode = defaults.boolForKey("mode")
        modeSwitch.on = mode
        setColors()
        
        // set tip and custom tip
        customTip.text = String(defaults.integerForKey("customTip"))
        let customTipLabel = customTip.text! + "%"
        tipControl.setTitle(customTipLabel, forSegmentAtIndex: 3)
    }
    
    func setColors() {
        let mode = defaults.boolForKey("mode")
        if(mode) {
            self.view.backgroundColor = UIColor.whiteColor()
            tipText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipControl.tintColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            modeText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            customTipText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            percentSignText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
       
        } else {
            self.view.backgroundColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipText.textColor = UIColor.whiteColor()
            tipControl.tintColor = UIColor.whiteColor()
            modeText.textColor = UIColor.whiteColor()
            customTipText.textColor = UIColor.whiteColor()
            percentSignText.textColor = UIColor.whiteColor()
        }
    }
    
    @IBAction func saveIndex(sender: UISegmentedControl) {
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipSelectedSegmentIndex")
        defaults.synchronize()
    }
    
    @IBAction func saveCustomTipAndUpdateLabel(sender: AnyObject) {
        let customTipPercent = customTip.text! == "" ? "0" : customTip.text!
        defaults.setInteger(Int(customTipPercent)!, forKey: "customTip")
        defaults.synchronize()
        
        let customTipLabel = customTipPercent + "%"
        tipControl.setTitle(customTipLabel, forSegmentAtIndex: 3)
    }
    
    @IBAction func changeMode(sender: AnyObject) {
        let mode = modeSwitch.on
        defaults.setBool(mode, forKey: "mode")
        defaults.synchronize()
        setColors()
    }
    
    @IBAction func clearField(sender: AnyObject) {
        customTip.text! = ""
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
}
