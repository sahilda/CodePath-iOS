//
//  TwitterClient.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/30/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: APIKey.CONSUMER_KEY, consumerSecret: APIKey.CONSUMER_SECRET)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func destroyRetweet(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        let endpoint = "1.1/statuses/unretweet/\(id).json"
        
        post(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func createRetweet(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        let endpoint = "1.1/statuses/retweet/\(id).json"
        
        post(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func destroyFavorite(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        let endpoint = "1.1/favorites/destroy.json?id=\(id)"
        
        post(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func createFavorite(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        let endpoint = "1.1/favorites/create.json?id=\(id)"
        
        post(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func postStatus(tweet: String, reply_id: Int? = nil, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        let tweet_encoded = tweet.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var endpoint = "1.1/statuses/update.json?status=\(tweet_encoded!)"
        
        if reply_id != nil {
            endpoint = "1.1/statuses/update.json?in_reply_to_status_id=\(reply_id!)&status=\(tweet_encoded!)"
        }
        
        post(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func userMentions(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func userTimeline(screenname: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func getMoreTimeline(id: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let endpoint = "1.1/statuses/home_timeline.json?max_id=\((id-1))"
        get(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User.init(dictionary: userDictionary)
                success(user)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func getUser(screenname: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/users/show.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User.init(dictionary: userDictionary)
                success(user)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func getAccountBannerUrl(screenname: String, success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/users/profile_banner.json?screen_name=\(screenname)", parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionary = response as! NSDictionary
                let sizes = dictionary["sizes"] as! NSDictionary
                let mobile_retina = sizes["mobile_retina"] as! NSDictionary
                let url = mobile_retina["url"] as! String
                success(url)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    
    func login(success: @escaping () -> () , failure: @escaping (Error) -> () ) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "tweetBeat://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential?) -> Void in
            let token = requestToken?.token
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)")
            UIApplication.shared.open(url!)
        }, failure: {(error: Error?) -> Void in
            print("error: \(error?.localizedDescription).")
            self.loginFailure?(error!)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential?) -> Void in
            
                self.currentAccount(success: {(user: User) -> () in
                    User.currentUser = user
                    
                    if User.userAlreadyLoggedIn(user: user) {
                        // do nothing
                    } else {
                        User.loggedInUsers?.append(user)
                    }
                    
                    
                    self.loginSuccess?()
                }, failure: { (error: Error) -> () in
                    self.loginFailure?(error)
                })
            
            }, failure: {(error: Error?) -> Void in
                self.loginFailure!(error!)
        })
    }
    
    func logout() {
        User.removeLoggedInUser(user: User.currentUser!)
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        
        /*
        if User.loggedInUsers?.count == 0 {
            deauthorize()
            User.currentUser = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        } else {
            User.currentUser = User.loggedInUsers?[0]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.newUserNotification), object: nil)
        }
         */
    }

}
