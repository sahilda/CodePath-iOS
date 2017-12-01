//
//  MentionsCell.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 11/7/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class MentionsCell: UITableViewCell {
    
    var tweetId: Int = 0
    var tweet: Tweet!    

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    func loadData() {
        profileImageView.setImageWith(tweet.profileURL!)
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 7
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
