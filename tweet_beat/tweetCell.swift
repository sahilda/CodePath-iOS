//
//  tweetCell.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/31/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class tweetCell: UITableViewCell {
    
    var tweetId: Int = 0
    var tweet: Tweet!

    @IBOutlet weak var avatorImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var tweetTextView: UITextView!
    
    func loadData() {
        avatorImageView.setImageWith(tweet.profileURL!)
        nameLabel.text = tweet.name
        usernameLabel.text = "@\(tweet.screenname!)"
        dateLabel.text = tweet.timeback
        tweetTextView.text = tweet.text
        tweetId = tweet.id
    }
    
    @IBAction func retweetButtonPressed(_ sender: AnyObject) {
        
        if (!retweetButton.isSelected) {
            retweetButton.isSelected = true
            TwitterClient.sharedInstance?.createRetweet(id: tweetId, success: { (tweet: Tweet) -> () in
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        } else {
            retweetButton.isSelected = false
            TwitterClient.sharedInstance?.destroyRetweet(id: tweetId, success: { (tweet: Tweet) -> () in
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        }
        
    }

    @IBAction func likedButtonPressed(_ sender: AnyObject) {
        
        if (!likeButton.isSelected) {
            likeButton.isSelected = true
            TwitterClient.sharedInstance?.createFavorite(id: tweetId, success: { (tweet: Tweet) -> () in
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        } else {
            likeButton.isSelected = false
            TwitterClient.sharedInstance?.destroyFavorite(id: tweetId, success: { (tweet: Tweet) -> () in
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
            })
        }
        
    }
}
