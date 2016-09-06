//
//  ViewController.swift
//  goodtips
//
//  Created by Sahil Agarwal on 8/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var venmoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Focus on billField upon opening
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipSelectedSegmentIndex = defaults.integerForKey("tipSelectedSegmentIndex")
        tipControl.selectedSegmentIndex = tipSelectedSegmentIndex
        
        billField.text = defaults.objectForKey("billField") == nil ? "$" : defaults.objectForKey("billField") as! String
        
        self.calculateTip("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(sender: AnyObject) {
        let tipPercentages = [0.15, 0.2, 0.25]
        
        let userInput = String(billField.text!) ?? ""
        let bill = Double(userInput.stringByReplacingOccurrencesOfString("$", withString: "")) ?? 0
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    @IBAction func saveTipSelectorIndex(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipSelectedSegmentIndex")
        defaults.synchronize()
    }
    
    @IBAction func saveBillAmount(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billField.text!, forKey: "billField")
        defaults.synchronize()
    }
    
    @IBAction func openVenmo(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.venmo.com")!)
    }
    
    @IBAction func openSwarm(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.swarmapp.com/")!)
    }
}

