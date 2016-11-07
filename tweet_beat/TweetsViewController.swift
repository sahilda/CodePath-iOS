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
    var user = User.currentUser!
    var isMoreDataLoading = false
    var leastID = 0
    var hamburgerVC: HamburgerViewController!
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableViewDefaults()
        loadNavigationBar()
        loadRefreshControl()
        getTweets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getTweets()
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
    }
    
    func getTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.leastID = self.getLeastID(tweets: self.tweets)
            if (refreshControl != nil) {
                refreshControl?.endRefreshing()
            }
            self.tableView.reloadData()
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
        })
    }

}

// MARK: table view functions

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweet
        cell.hamburgerVC = hamburgerVC
        cell.loadData()
        avatorTapGesture(target: cell.avatorImageView)
        
        
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
    
    func avatorTapGesture(target: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        target.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: location)
        let tweet = tweets[(indexPath?.row)!]
    
        let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        profileVC.hamburgerVC = hamburgerVC
        profileVC.screenname = tweet.screenname!
        hamburgerVC.contentViewController = profileVC
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tweet = tweets[indexPath.row]
        let tweetDetailsNavigation = storyBoard.instantiateViewController(withIdentifier: "tweetDetailsNavigation") as! UINavigationController
        let tweetDetailsVC = tweetDetailsNavigation.topViewController as! TweetDetailsViewController
        tweetDetailsVC.tweet = tweet
        tweetDetailsVC.user = user
        self.dismiss(animated: false, completion: nil)
        self.present(tweetDetailsNavigation, animated: true, completion: nil)
    }
    
}

// MARK: segue code

extension TweetsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        if (navigationController.restorationIdentifier == "composeNavigation") {
            let vc = navigationController.topViewController as! ComposeTweetViewController
            vc.user = user
        }
    }
    
}

// MARK: Never ending scrolling code

extension TweetsViewController {
    
    func getMoreTweets() {
        TwitterClient.sharedInstance?.getMoreTimeline(id: leastID, success: { (tweets: [Tweet]) -> () in
            self.tweets = self.tweets + tweets
            self.leastID = self.getLeastID(tweets: tweets)
            self.isMoreDataLoading = false
            self.tableView.reloadData()            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    func getLeastID(tweets: [Tweet]) -> Int {
        var leastID: Int?
        for tweet in tweets {
            if (leastID == nil || (tweet.id < leastID!)) {
                leastID = tweet.id
            }
        }
        return leastID!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                getMoreTweets()
            }
        }
    }
}
