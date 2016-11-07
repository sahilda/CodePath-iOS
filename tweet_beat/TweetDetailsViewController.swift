//
//  TweetDetailsViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    var user: User!
    var tweet: Tweet!
    var liked = false
    var likedCount = 0
    var retweeted = false
    var retweetedCount = 0
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadNavigationBar()
        loadTweetDate()
        loadButtons()
    }

    func loadNavigationBar() {
        navigationController?.navigationBar.barTintColor = TwitterBlueColor.getTwitterBlueColor()
        let logo = UIImage(named: "twitter_white_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    func loadTweetDate() {
        avatorImageView.setImageWith(tweet.profileURL!)
        tweetTextView.text = tweet.text        
        nameLabel.text = tweet.name
        usernameLabel.text = tweet.screenname
        dateLabel.text = tweet.timestamp
        retweetedCount = tweet.retweetCount
        retweetsCountLabel.text = "\(retweetedCount)"
        likedCount = tweet.favoritesCount
        favoritesCountLabel.text = "\(likedCount)"
        liked = tweet.favorited
        retweeted = tweet.retweeted
    }
    
    func loadButtons() {
        
        if(retweeted) {
            retweetButton.isSelected = true
        } else {
            retweetButton.isSelected = false
        }
        
        if(liked) {
            likeButton.isSelected = true
        } else {
            likeButton.isSelected = false
        }
        
    }
    
    @IBAction func homeButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retweetButtonPressed(_ sender: AnyObject) {
        if (!retweetButton.isSelected) {
            retweetButton.isSelected = true
            TwitterClient.sharedInstance?.createRetweet(id: tweet.id, success: { (tweet: Tweet) -> () in
                self.retweetedCount = self.retweetedCount + 1
                self.retweetsCountLabel.text = "\(self.retweetedCount)"
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        } else {
            retweetButton.isSelected = false
            TwitterClient.sharedInstance?.destroyRetweet(id: tweet.id, success: { (tweet: Tweet) -> () in
                self.retweetedCount = self.retweetedCount - 1
                self.retweetsCountLabel.text = "\(self.retweetedCount)"
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: AnyObject) {
        if (!likeButton.isSelected) {
            likeButton.isSelected = true
            TwitterClient.sharedInstance?.createFavorite(id: tweet.id, success: { (tweet: Tweet) -> () in
                self.likedCount = self.likedCount + 1
                self.favoritesCountLabel.text = "\(self.likedCount)"
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        } else {
            likeButton.isSelected = false
            TwitterClient.sharedInstance?.destroyFavorite(id: tweet.id, success: { (tweet: Tweet) -> () in
                self.likedCount = self.likedCount - 1
                self.favoritesCountLabel.text = "\(self.likedCount)"
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        }
    }
    
}

extension TweetDetailsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        if (navigationController.restorationIdentifier == "composeNavigation") {
            let vc = navigationController.topViewController as! ComposeTweetViewController
            vc.user = user
            vc.reply_id = tweet.id
            vc.startingText = "@\(tweet.screenname!) "
        }
    }
    
}

