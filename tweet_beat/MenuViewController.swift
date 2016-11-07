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
        
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.user = User.currentUser
        profileVC.hamburgerVC = hamburgerViewController
        
        viewControllers.append(profileVC)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 3 {
            TwitterClient.sharedInstance?.logout()
        } else {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let titles = ["profile", "Timeline", "Mentions", "Logout"]
        let images = ["", "home", "mentions", "logout"]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstMenuTableViewCell", for: indexPath) as! FirstMenuTableViewCell
            cell.loadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
            cell.titleLabel.text = titles[indexPath.row]
            cell.logoImageView.image = UIImage(named: images[indexPath.row])
            return cell
        }
    }

}
