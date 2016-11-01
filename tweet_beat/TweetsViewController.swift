//
//  TweetsViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/30/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableViewDefaults()
        loadNavigationBar()
        loadRefreshControl()
        getTweets()
        user = User.currentUser!
        
        postTweet(tweet: "yay")
    }
    
    func getTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            if (refreshControl != nil) {
                refreshControl?.endRefreshing()
            }
            
            self.tableView.reloadData()
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
        })
    }
    
    func loadTableViewDefaults() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    func loadNavigationBar() {
        navigationController?.navigationBar.barTintColor = TwitterBlueColor.getTwitterBlueColor()
        let logo = UIImage(named: "twitter_white_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    func loadRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getTweets(refreshControl: refreshControl)
        tableView.reloadData()
    }
    
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }

}

extension TweetsViewController: ComposeTweetDelegate {
    
    func sendTweet(sender: ComposeTweetViewController, tweet: String) {
        dismiss(animated: true, completion: nil)
        postTweet(tweet: tweet)
    }
    
    func postTweet(tweet: String) {
        TwitterClient.sharedInstance?.postStatus(tweet: tweet, success: { (tweet: Tweet) -> () in
            print("posted.")
            self.getTweets()
            self.tableView.reloadData()
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
        
        cell.avatorImageView.setImageWith(tweet.profileURL!)
        cell.nameLabel.text = tweet.name
        cell.usernameLabel.text = "@\(tweet.screenname!)"
        cell.dateLabel.text = tweet.timeback
        cell.tweetLabel.text = tweet.text
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TweetsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        if (navigationController.restorationIdentifier == "composeNavigation") {
            let vc = navigationController.topViewController as! ComposeTweetViewController
            vc.avatorURL = user.profileURL!
            vc.name = user.name!
            vc.screenname = "@\(user.screenname!)"
            vc.delegate = self
        }
        
        if (navigationController.restorationIdentifier == "detailsNavigation") {
            let vc = navigationController.topViewController as! TweetDetailsViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            vc.tweet = tweet
        }
    }
}
