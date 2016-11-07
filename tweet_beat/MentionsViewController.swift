//
//  MentionsViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/7/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
    
    var tweets: [Tweet]!
    var hamburgerVC: HamburgerViewController!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigationBar()
        loadTableViewDefaults()
        getTweets()
    }
    
    func loadNavigationBar() {
        navigationController?.navigationBar.barTintColor = TwitterBlueColor.getTwitterBlueColor()
        let logo = UIImage(named: "twitter_white_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    func getTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance?.userMentions(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            if (refreshControl != nil) {
                refreshControl?.endRefreshing()
            }
            self.tableView.reloadData()
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
        })
    }

}

extension MentionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsCell", for: indexPath) as! MentionsCell
        
        cell.tweet = tweet
        cell.loadData()
        
        let retweeted = tweet.retweeted
        let liked = tweet.favorited
        
        if(retweeted) {
            cell.retweetButton.isSelected = true
        } else {
            cell.retweetButton.isSelected = false
        }
        
        if(liked) {
            cell.likeButton.isSelected = true
        } else {
            cell.likeButton.isSelected = false
        }
        
        return cell
    }
    
    func loadTableViewDefaults() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
    }
}

