//
//  ViewController.swift
//  goodtips
//
//  Created by Sahil Agarwal on 8/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet var mainView: UIView!
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
        
        // Show Title Screen on when app first opens
        self.titleView.alpha = 1
        
        UIView.animateWithDuration(1.5, animations: {
            self.titleView.alpha = 0
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        // set colors based on mode selection
        setColors()
        
        // load previously saved data (bill field and selected tip controller)
        let tipSelectedSegmentIndex = defaults.integerForKey("tipSelectedSegmentIndex")
        tipControl.selectedSegmentIndex = tipSelectedSegmentIndex
        let customTipLabel = String(defaults.integerForKey("customTip")) + "%"
        tipControl.setTitle(customTipLabel, forSegmentAtIndex: 3)
        billField.text! = defaults.objectForKey("billField") == nil ? "0" : defaults.objectForKey("billField") as! String
        
        // setup fiel placeholder text
        blankInput()
        
        // set tipPercentageLabel
        setTipPercentageLabel()
        
        // calculate tip
        calculateTip("")
        
        // Focus on billField upon opening
        billField.becomeFirstResponder()
    }

    // hides keyboard on tap
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    // setups app colors based on mode selected
    func setColors() {
        let mode = defaults.boolForKey("mode")
        tipControl.tintColor = UIColor.whiteColor()
        billField.textColor = UIColor.whiteColor()
        
        if(mode) {
            self.view.backgroundColor = UIColor.whiteColor()
            tipText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipPercentageLabel.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipLabel.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            totalText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            totalLabel.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            
            RoundUpButton.backgroundColor = UIColor.whiteColor()
            RoundUpButton.titleLabel?.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            RoundUpButton.setTitleColor(UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0), forState: UIControlState.Normal)
            RoundUpButton.layer.cornerRadius = 5
            RoundUpButton.layer.borderWidth = 1
            RoundUpButton.layer.borderColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0).CGColor
            RoundUpButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            
            openText.textColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
        
        } else {
            self.view.backgroundColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            tipText.textColor = UIColor.whiteColor()
            tipPercentageLabel.textColor = UIColor.whiteColor()
            tipLabel.textColor = UIColor.whiteColor()
            totalText.textColor = UIColor.whiteColor()
            totalLabel.textColor = UIColor.whiteColor()
            
            RoundUpButton.backgroundColor = UIColor(red: 29/255, green: 162/255, blue: 19/255, alpha: 1.0)
            RoundUpButton.titleLabel?.textColor = UIColor.whiteColor()
            RoundUpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            RoundUpButton.layer.cornerRadius = 5
            RoundUpButton.layer.borderWidth = 1
            RoundUpButton.layer.borderColor = UIColor.whiteColor().CGColor
            RoundUpButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            
            openText.textColor = UIColor.whiteColor()
        }
    }
    
    func setTipPercentageLabel() {
        let bill = Double(billField.text!) == nil ? 0 : Double(billField.text!)
        let tip = total - bill!
        let tipPercent = total == 0 ? " " : String(Int(round(tip / (total-tip) * 100)))
        tipPercentageLabel.text = "(" + tipPercent + "%)"
    }
    
    func blankInput() {
        if billField.text! == "" {
            let locale = NSLocale.currentLocale()
            let currencySymbol = locale.objectForKey(NSLocaleCurrencySymbol)!
            billField.placeholder=currencySymbol as! String
            
            UIView.animateWithDuration(0.35, animations: {
                self.view.backgroundColor = UIColor(red: 22/255, green: 127/255, blue: 16/255, alpha: 1.0)
                let color = self.view.backgroundColor
                self.tipText.textColor = color
                self.tipPercentageLabel.textColor = color
                self.tipLabel.textColor = color
                self.totalText.textColor = color
                self.totalLabel.textColor = color
                
                self.RoundUpButton.backgroundColor = color
                self.RoundUpButton.titleLabel?.textColor = color
                self.RoundUpButton.setTitleColor(color, forState: UIControlState.Normal)
                self.RoundUpButton.layer.borderColor = color!.CGColor
            })
        
        } else {
            UIView.animateWithDuration(0.35, animations: {
                self.setColors()
            })
        }
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
        blankInput()
        
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
        let input = billField.text! == "" ? "0" : billField.text!
        let ceilTip = ceilTotal - Double(input)!
        
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

