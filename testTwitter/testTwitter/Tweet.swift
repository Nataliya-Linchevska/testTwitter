//
//  Tweet.swift
//  testTwitter
//
//  Created by user on 07.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import Foundation
class Tweet {
    
    var tweetID: NSNumber?          // ідентифікатор на конкретний твіт
    var screenName: NSString?       // ім"я користувача
    var author: NSString?           // @ім"я користувача
    var authorProfilePicURL: NSURL? // посилання на аватарку користувача
    var urls: [NSDictionary]?       // посилання в тексті
    var media: [NSDictionary]?      // картинки в тексті
    var text: NSString?             // текст твіту
    var timestamp: NSDate?          // час
    var retweetsCount: Int = 0      // кількість ретвітів
    var favoritesCount: Int = 0     // кількість лайків
    
    var favorited: Bool {            // чи поставлений лайк користувачем
        didSet {
            if favorited {
                favoritesCount += 1 // збільшуємо кількість лайків
            } else {
                favoritesCount -= 1

            }
        }
    }
    
    var retweeted: Bool {            // чи ретвітнутий пост користувачем
        didSet {
            if retweeted {
                retweetsCount += 1  // збільшуємо кількість ретвітів
            } else {
                retweetsCount -= 1
                
            }
        }
    }
    
    init (dictionary: NSDictionary) {
        tweetID = dictionary["id"] as! NSNumber
        urls = (dictionary["entities"] as? NSDictionary)?["urls"] as? [NSDictionary]
        media = (dictionary["entities"] as? NSDictionary)?["media"] as? [NSDictionary]
        
        screenName = ((dictionary["user"]! as? NSDictionary)?["screen_name"] as? NSString?)!
        author = (dictionary["user"] as? NSDictionary)?["name"] as? NSString
        authorProfilePicURL = NSURL(string: ((dictionary["user"]!as? NSDictionary)?["profile_image_url_https"] as! String).replace(target: "normal.png", withString: "bigger.png"))!
        
        text = dictionary["text"] as? NSString
        retweetsCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favorited = (dictionary["favorited"] as? Bool) ?? false
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary])->[Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

}











