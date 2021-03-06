//
//  User.swift
//  tweet_beat
//
//  Created by Sahil Agarwal on 10/29/16.
//  Copyright © 2016 Sahil Agarwal. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = "userDidLogout"
    static let newUserNotification = "newUser"
    var dictionary: NSDictionary?
    var name: String?
    var screenname: String?
    var profileURL: URL?
    var tagline: String?
    var followers_count: Int?
    var following: Int?
    var location: String?
    var tweet_count: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name =  dictionary["name"] as? String
        screenname =  dictionary["screen_name"] as? String
        let profileURLString =  dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            profileURL = URL(string: profileURLString)
        }        
        tagline =  dictionary["description"] as? String
        followers_count = dictionary["followers_count"] as? Int
        following = dictionary["friends_count"] as? Int
        location = dictionary["location"] as? String
        tweet_count = dictionary["statuses_count"] as? Int
    }
    
    static var _loggedInUsers: [User]?
    class var loggedInUsers: [User]? {
        get {
            if _loggedInUsers == nil {
                let defaults = UserDefaults.standard
                let loggedInUsersData = defaults.object(forKey: "loggedInUserData") as? [Data]
                
                if let loggedInUsersData = loggedInUsersData {
                    
                    for userData in loggedInUsersData {
                        let dictionary = try? JSONSerialization.jsonObject(with: userData as Data, options: [])
                        if dictionary == nil {
                            _loggedInUsers = nil
                        } else {
                            let user = User(dictionary: dictionary as! NSDictionary)
                            _loggedInUsers?.append(user)
                        }
                    }
                    
                }
            }
            return _loggedInUsers
        }
        set(loggedInUsers) {
            let defaults = UserDefaults.standard
            if let loggedInUsers = loggedInUsers {
                var dictionary = NSDictionary()
                var users = [Data]()
                for user in loggedInUsers {
                    let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                    users.append(data)
                }
                
                dictionary = ["users": users]
                defaults.set(dictionary, forKey: "loggedInUserData")
            } else {
                defaults.removeObject(forKey: "loggedInUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    static func userAlreadyLoggedIn(user: User) -> Bool {
        if loggedInUsers == nil {
            return false
        }
        
        for loggedInUser in loggedInUsers! {
            if user.screenname == loggedInUser.screenname {
                return true
            }
        }
        return false
    }
    
    static func removeLoggedInUser(user: User) {
        /*
        for (index, loggedInUser) in loggedInUsers!.enumerated() {
            if user.screenname == loggedInUser.screenname {
                loggedInUsers?.remove(at: index)
            }
        }
        */
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try? JSONSerialization.jsonObject(with: userData as Data, options: [])
                    if dictionary == nil {
                        _currentUser = nil
                    } else {
                        _currentUser = User(dictionary: dictionary as! NSDictionary)
                    }
                    
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
