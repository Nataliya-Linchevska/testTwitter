//
//  HomeViewController.swift
//  testTwitter
//
//  Created by user on 07.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // автоматичне вираховування висоти ячейки
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets == nil) {
            return 0
        } else {
            return tweets!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! TweetCompactCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    func reloadData() {
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }

}













