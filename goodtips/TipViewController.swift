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
    let currencyFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // load data
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipSelectedSegmentIndex = defaults.integerForKey("tipSelectedSegmentIndex")
        tipControl.selectedSegmentIndex = tipSelectedSegmentIndex
        billField.text! = defaults.objectForKey("billField") == nil ? "0" : defaults.objectForKey("billField") as! String
        
        // set custom tip label
        let customTipLabel = String(defaults.integerForKey("customTip")) + "%"
        tipControl.setTitle(customTipLabel, forSegmentAtIndex: 3)
        
        // calculate tip
        self.calculateTip("")
        
        // Focus on billField upon opening
        billField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func changeNumberToCurrency(number : Double) -> String {
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
        
        return currencyFormatter.stringFromNumber(number)!
    }
    
    func getCustomTipPercentage() -> Double {
        let defaults = NSUserDefaults.standardUserDefaults()
        return Double(defaults.integerForKey("customTip")) / 100
    }
    
    @IBAction func calculateTip(sender: AnyObject) {
        let tipPercentages = [0.15, 0.2, 0.25, getCustomTipPercentage()]
        
        let userInput = Double(billField.text!) == nil ? 0 : Double(billField.text!)
        
        let tip = userInput! * tipPercentages[tipControl.selectedSegmentIndex]
        let total = userInput! + tip
        
        tipLabel.text = changeNumberToCurrency(tip)
        totalLabel.text = changeNumberToCurrency(total)
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

