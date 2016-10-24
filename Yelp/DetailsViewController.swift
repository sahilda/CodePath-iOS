//
//  detailsViewController.swift
//  Yelp
//
//  Created by Sahil Agarwal on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var backBarButton: UIBarButtonItem!
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = YelpRedColor.getYelpRedColor()
        
        print(business)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
