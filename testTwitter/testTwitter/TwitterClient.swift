//
//  TwitterClient.swift
//  testTwitter
//
//  Created by user on 06.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
//    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL! , consumerKey: "ooIpINcAHI40e1TiPpEcjtzPa", consumerSecret: "hB74SUb60EkCMZT6mvQVLWLpFaQIVYIhdAum4bKISTs57GSPBY")
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL! , consumerKey: "owS0EttRA6qTvvWyJSvUqsqLr", consumerSecret: "GCKGzRJFsErOcHMYEArnfTT2d6y6aCkZCWF6i2s26tz09FSXoy")
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError)->())?
    weak var delegate: TwitterLoginDelegate?
    
    // запрос токена методом відкриття авторизації в сафарі
    func login(success: @escaping ()->(), failure: @escaping (NSError)->()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "testTwitter://oauth"), scope: nil, success: { (requestToken) in
            print("Go token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token="+(requestToken?.token)!)
            UIApplication.shared.openURL(url as! URL)
        }) { (error) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        }
    }
    
    // получаємо токен і зберігаємо користувача
    func handleOpenUrl (url: NSURL) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.splashDelay = true
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            self.currentAccount(success: { (user: User) in
                //визиваю setter і зберігаю в нього користувача
                User.currentUser = user
                self.loginSuccess?()
                self.delegate?.continueLogin()
            }, failure: { (error) in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
        }) { (error) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error as! NSError)
        }
    }
    
    // корректний аккаунт (перевірка облікового запису користувача)
    func currentAccount(success: @escaping (User) ->(), failure: @escaping (NSError)->()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }) { (task, error) in
            print("error: \(error.localizedDescription)")
            failure(error as NSError)
        }
    }
    
    // отримання своєї новинної стрічки (GET home timeline json)
    func homeTimeLine(maxId: Int? = nil, success: @escaping ([Tweet])->(), failure: @escaping (NSError)->()) {
        var params = ["count": 10]
        // для догрузки наступної партії з 10 твітів
        if (maxId != nil) {
            params["max_id"] = maxId
        }
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task, response) in
//            print(response)
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }) { (task, error) in
            failure(error as NSError)
        }
    }
    
    //     запроси до своїх твітів користувача (GET user timeline json)
    func userTimeLine(user: User, maxId: Int? = nil, success: @escaping ([Tweet])->(), failure: @escaping (NSError)->()) {
        
        var params = ["count": 10]
        params["user_id"] = user.id!
        if (maxId != nil) {
            params["max_id"] = maxId
        }
        
        get("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }) { (task, error) in
            print("error: \(error.localizedDescription)")
            failure(error as NSError)
        }
    }
    
    // статус твітів/ретвітів юзера
    func retweet(params: NSDictionary?, retweet: Bool, completion: @escaping (_ tweet: Tweet?, _ error: Error?) ->()) {
        let tweetId = params!["id"] as! Int
        let endPoint = retweet ? "retweet" : "unretweet"
        post("1.1/statuses/\(endPoint)/\(tweetId).json", parameters: params, progress: nil, success: { (task, response) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
        }) { (task, error) in
            completion(nil, error)
        }
    }
    
    // статус лайк/дизлайк юзера
    func favorite(params: NSDictionary?, favorite: Bool, completion: @escaping (_ tweet: Tweet?, _ error: Error?) ->()) {
        let endPoint = favorite ? "create" : "destroy"
        post("1.1/favorites/\(endPoint).json", parameters: params, progress: nil, success: { (task, response) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
        }) { (task, error) in
            completion(nil, error)
        }
    }
    
    // публікація твітів
    func publishTweet(apiParam: NSDictionary, completion: @escaping (_ newTweet: Tweet?, _ error: Error?) ->()){
        post("1.1/statuses/update.json", parameters: apiParam, progress: nil, success: { (task, response) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet, nil)            
        }) { (task, error) in
            print("error creating tweet")
            completion(nil, error)
        }
    }
}








































