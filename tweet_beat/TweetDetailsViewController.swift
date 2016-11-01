//
//  TweetDetailsViewController.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
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
        tweetLabel.text = tweet.text
        nameLabel.text = tweet.name
        usernameLabel.text = tweet.screenname
        dateLabel.text = tweet.timestamp
        retweetsCountLabel.text = "\(tweet.retweetCount)"
        favoritesCountLabel.text = "\(tweet.favoritesCount)"
    }
    
    func loadButtons() {
        retweetButton.setImage(UIImage(named: "default_retweet"), for: .normal)
        likeButton.setImage(UIImage(named: "default_like"), for: .normal)
        replyButton.setImage(UIImage(named: "default_reply"), for: .normal)
    }
    
    @IBAction func homeButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func replyButton(_ sender: AnyObject) {
        
    }
    
    

}
