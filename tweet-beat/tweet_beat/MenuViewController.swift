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
    var users = User.loggedInUsers
    @IBOutlet weak var accountsTableView: UITableView!
    @IBOutlet weak var leftBarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNavigationBar()
        loadMenuVCs()
        loadTableViewDefaults()
        accountsTableView.reloadData()
    }
    
    func loadMenuVCs() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let timelineNavigationController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let timelineVC = timelineNavigationController.topViewController as! TweetsViewController
        timelineVC.hamburgerVC = hamburgerViewController
        
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.user = User.currentUser
        profileVC.hamburgerVC = hamburgerViewController
        
        let mentionsNavigation = storyBoard.instantiateViewController(withIdentifier: "MentionsNavigationController") as! UINavigationController
        let mentionsVC = mentionsNavigation.topViewController as! MentionsViewController
        mentionsVC.hamburgerVC = hamburgerViewController
        
        viewControllers.append(profileVC)
        viewControllers.append(timelineNavigationController)
        viewControllers.append(mentionsNavigation)
        hamburgerViewController.contentViewController = timelineNavigationController
    }
    
    func loadNavigationBar() {
        navigationController?.navigationBar.barTintColor = TwitterBlueColor.getTwitterBlueColor()
        leftBarItem.title = ""
    }
    
    @IBAction func onLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        if (sender.state == .ended) {
            if accountsTableView.isHidden {
                accountsTableView.isHidden = false
                leftBarItem.title = "Accounts"
            } else {
                accountsTableView.isHidden = true
                leftBarItem.title = ""
            }
        }
        
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
        
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        accountsTableView.rowHeight = UITableViewAutomaticDimension
        accountsTableView.estimatedRowHeight = 50
        accountsTableView.tableFooterView = UIView()
        accountsTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        accountsTableView.isHidden = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == self.tableView {
            if indexPath.row == 3 {
                TwitterClient.sharedInstance?.logout()
            } else {
                hamburgerViewController.contentViewController = viewControllers[indexPath.row]
            }
        } else {
            if indexPath.row == 1 {
                addNewAccount()
            } else {
                User.currentUser = User.currentUser
            }
            
            accountsTableView.isHidden = true
            leftBarItem.title = ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 4
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsCell") as! AccountsCell
            
            if indexPath.row == (1) {
                cell.nameLabel.text = "Add new user"
                cell.profileImageView.image = UIImage(named: "plus")
                cell.profileImageView.layer.borderWidth = 4
                cell.profileImageView.layer.borderColor = UIColor.darkGray.cgColor
                cell.profileImageView.isUserInteractionEnabled = true
            } else {
                let user = User.currentUser
                cell.nameLabel.text = user?.name
                cell.profileImageView.setImageWith((user?.profileURL)!)
            }
            
            return cell
        }
    }
    
    func addNewAccount() {
        TwitterClient.sharedInstance?.login(success: { () -> () in
            let hamburgerViewController = HamburgerMenuLoader.loadHamburgetMenu()
            self.present(hamburgerViewController, animated: true)
        }, failure: { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        })
    }
    
}
