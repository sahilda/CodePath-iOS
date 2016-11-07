//
//  ProfileViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/6/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var navigationBarHeight = 64
    var screenname: String!
    var user: User!
    var hamburgerVC: HamburgerViewController!
    var backgroundProfileUrl: URL?
    var tweets: [Tweet]!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UITextView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundProfileImageView: UIImageView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tweetCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = TwitterBlueColor.getTwitterBlueColor()
        loadTableViewDefaults()
        
        if user == nil {
            getUserData(screenname: screenname)
        } else {
            loadData()
        }
        
    }

    func loadData() {
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.screenname!)"
        taglineLabel.text = user?.tagline
        followersCountLabel.text = "\(user.followers_count!)"
        followingCountLabel.text = "\(user.following!)"
        tweetCountLabel.text = "\(user.tweet_count!) Tweets"
        
        if user.profileURL != nil {
            profileImageView.layer.masksToBounds = true
            profileImageView.setImageWith((user.profileURL)!)
            profileImageView.layer.cornerRadius = 7
            profileImageView.layer.borderWidth = 3
            profileImageView.layer.borderColor = UIColor.white.cgColor
        }
        
        getBannerUrl()
        getTweets()
    }
    
    func getUserData(screenname: String) {
        TwitterClient.sharedInstance?.getUser(screenname: screenname, success:{ (user: User) -> () in
                self.user = user
                self.loadData()
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
        })
    }
    
    func getBannerUrl() {
        TwitterClient.sharedInstance?.getAccountBannerUrl(screenname: user.screenname!, success:{ (url: String) -> () in
            self.backgroundProfileUrl = URL(string: url)
                self.backgroundProfileImageView.setImageWith(self.backgroundProfileUrl!)
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    func getTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance?.userTimeline(screenname: user.screenname!, success: { (tweets: [Tweet]) -> () in
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTweetCell", for: indexPath) as! ProfileTweetCell
        
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
