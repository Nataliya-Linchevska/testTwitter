//
//  User.swift
//  testTwitter
//
//  Created by user on 06.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static var tempUser: User?

    static let userDidLogoutNotification = "UserDidLogout"
    
    var id: Int? // id користувача
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var backgroundImageUrl: String?
    var usingBannerImage = true
    var followersCount: Int?
    var followingCount: Int?
    
    var dictionary: NSDictionary?
    static var _currentUser: User?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary["id"] as? Int
        
        name = dictionary["name"] as? String as NSString?
        screenName = dictionary["screen_name"] as? String as NSString?
        
        backgroundImageUrl = dictionary["profile_banner_url"] as? String
        if (backgroundImageUrl != nil) {
            backgroundImageUrl?.append("/600x200")
        } else {
            backgroundImageUrl = dictionary["profile_background_image_url_https"] as? String
            usingBannerImage = false
        }
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        profileUrl = NSURL(string: (profileUrlString?.replace(target: "normal.png", withString: "bigger.png"))!)
        
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        
    }
    
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? NSData
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
        }
    }
}






