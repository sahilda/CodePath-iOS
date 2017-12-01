//
//  SettingsViewController.swift
//  GithubDemo
//
//  Created by Sahil Agarwal on 10/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var delegate: StarsSliderDelegate?
    @IBOutlet weak var ForksSlider: UISlider!
    
    var filteredStars: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sliderViewChanged(_ sender: UISlider) {
        self.filteredStars = sender.value
    }

    @IBAction func touchSave(_ sender: AnyObject) {
        delegate?.starPicker(picker: self, didPickStar: filteredStars)
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RepoResultsViewController
        vc.filteredStars = Int(self.filteredStars)
    }
}

protocol StarsSliderDelegate: class {
    func starPicker(picker: SettingsViewController, didPickStar star: Float?)
}
