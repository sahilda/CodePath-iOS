//
//  Tweet.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/29/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var name: String?
    var screenname: String?
    var profileURL: URL?
    var text: String?
    var timeback: String?
    var timestamp: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweeted = false
    var favorited = false
    var id = 0
    
    init(dictionary: NSDictionary) {
        let user = dictionary["user"] as? NSDictionary
        
        name =  user?["name"] as? String
        screenname =  user?["screen_name"] as? String
        let profileURLString =  user?["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }
        
        id = (dictionary["id"] as? Int)!
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = (dictionary["retweeted"] as? Bool)!
        favoritesCount = (user?["favourites_count"] as? Int) ?? 0
        favorited = (dictionary["favorited"] as? Bool)!
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMMM d HH:mm:ss Z y"
            let datetimestamp = formatter.date(from: timestampString)
            timeback = "⋅ \(SimpleDateFormatter.getTimeAgoSimple(date: datetimestamp!))"
            timestamp = SimpleDateFormatter.getTimestamp(date: datetimestamp!)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
