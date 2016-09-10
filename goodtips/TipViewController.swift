//
//  ViewController.swift
//  goodtips
//
//  Created by Sahil Agarwal on 8/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billText: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipText: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalText: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var RoundUpButton: UIButton!
    @IBOutlet weak var openText: UILabel!
    
    let currencyFormatter = NSNumberFormatter()
    let defaults = NSUserDefaults.standardUserDefaults()
    var total = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // set colors
        setColors()
        
        // load data
        let tipSelectedSegmentIndex = defaults.integerForKey("tipSelectedSegmentIndex")
        tipControl.selectedSegmentIndex = tipSelectedSegmentIndex
        billField.text! = defaults.objectForKey("billField") == nil ? "0" : defaults.objectForKey("billField") as! String
        
        // set custom tip label
        let customTipLabel = String(defaults.integerForKey("customTip")) + "%"
        tipControl.setTitle(customTipLabel, forSegmentAtIndex: 3)
        
        // set tipPercentageLabel
        setTipPercentageLabel()
        
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
    
    func setColors() {
        let mode = defaults.boolForKey("mode")
        if(mode) {
            self.view.backgroundColor = UIColor.whiteColor()
            billText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipPercentageLabel.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipLabel.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            totalText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            totalLabel.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipControl.tintColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            RoundUpButton.backgroundColor = UIColor.whiteColor()
            RoundUpButton.titleLabel?.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            openText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
        } else {
            self.view.backgroundColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            billText.textColor = UIColor.whiteColor()
            tipText.textColor = UIColor.whiteColor()
            tipPercentageLabel.textColor = UIColor.whiteColor()
            tipLabel.textColor = UIColor.whiteColor()
            totalText.textColor = UIColor.whiteColor()
            totalLabel.textColor = UIColor.whiteColor()
            tipControl.tintColor = UIColor.whiteColor()
            RoundUpButton.backgroundColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            RoundUpButton.titleLabel?.textColor = UIColor.whiteColor()
            openText.textColor = UIColor.whiteColor()
        }
    }
    
    func setTipPercentageLabel() {
        let tip = total - Double(billField.text!)!
        let tipPercent = total == 0 ? " " : String(Int(round(tip / (total-tip) * 100)))
        tipPercentageLabel.text = "(" + tipPercent + "%)"
    }
    
    func changeNumberToCurrency(number : Double) -> String {
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.currencyCode = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencySymbol, value: NSLocaleCurrencyCode)
        
        return currencyFormatter.stringFromNumber(number)!
    }
    
    func getCustomTipPercentage() -> Double {
        return Double(defaults.integerForKey("customTip")) / 100
    }
    
    @IBAction func calculateTip(sender: AnyObject) {
        let tipPercentages = [0.15, 0.2, 0.25, getCustomTipPercentage()]
        
        let userInput = Double(billField.text!) == nil ? 0 : Double(billField.text!)
        
        let tip = userInput! * tipPercentages[tipControl.selectedSegmentIndex]
        total = userInput! + tip
        
        tipLabel.text = changeNumberToCurrency(tip)
        totalLabel.text = changeNumberToCurrency(total)
        
        // set tipPercentageLabel
        setTipPercentageLabel()
    }
    
    @IBAction func RoundUpTotal(sender: AnyObject) {
        let ceilTotal = ceil(total)
        let ceilTip = ceilTotal - Double(billField.text!)!
        
        tipLabel.text = changeNumberToCurrency(ceilTip)
        totalLabel.text = changeNumberToCurrency(ceilTotal)
        total = ceilTotal
        
        // set tipPercentageLabel
        setTipPercentageLabel()
    }

    @IBAction func saveTipSelectorIndex(sender: AnyObject) {
        defaults.setInteger(tipControl.selectedSegmentIndex, forKey: "tipSelectedSegmentIndex")
        defaults.synchronize()
    }
    
    @IBAction func saveBillAmount(sender: AnyObject) {
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

