//
//  MenuViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/5/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var timelineViewController: UIViewController!
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTableViewDefaults()
        loadNavigationBar()
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let timelineNavigationController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let timelineVC = timelineNavigationController.topViewController as! TweetsViewController
        timelineVC.hamburgerVC = hamburgerViewController
        
        viewControllers.append(timelineNavigationController)
        hamburgerViewController.contentViewController = timelineNavigationController
    }
    
    func loadNavigationBar() {
        navigationController?.navigationBar.barTintColor = TwitterBlueColor.getTwitterBlueColor()
    }
    
}

// MARK: Functions for how the menu table view looks

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func loadTableViewDefaults() {
        tableView.delegate =  self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        let titles = ["Home", "Profile", "Mentions"]
        cell.titleLabel.text = titles[indexPath.row]
        return cell
    }

}
