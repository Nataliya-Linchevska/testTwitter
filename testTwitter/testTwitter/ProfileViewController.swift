//
//  ProfileViewController.swift
//  testTwitter
//
//  Created by user on 11.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwitterTableViewDelegate {
    
    
    @IBOutlet weak var ivBackgroundImage: UIImageView!
    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    var lastTweetId: Int?
    
    var user: User! {
        didSet {
            configureViewController()
        }
    }
    
    var tweets: [Tweet]? {
        didSet {
            self.lastTweetId = tweets![tweets!.endIndex - 1].tweetID as? Int // отримуємо останній id твіта
        }
    }
    
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ProfileConfigureView"), object: nil, queue: OperationQueue.main) { (notification) in
//            self.configureViewController()
            if User.tempUser != nil {
                self.user = User.tempUser
            }
        }        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        user = User.currentUser!
    }
    
    func configureViewController() {
        lblName.text = user.name as? String
        lblScreenName.text = "@" + (user.screenName as? String)!
        lblFollowers.text = "Followers: " + String(user.followersCount!)
        lblFollowing.text = "Following: " + String(user.followingCount!)

        
        let profileImageUrl = user.profileUrl
        let backgroundImageUrl = user.backgroundImageUrl
        ivProfileImage.setImageWith(profileImageUrl! as URL)
        
        if let backgroundImageUrl = backgroundImageUrl {
            ivBackgroundImage.setImageWith(NSURL(string: backgroundImageUrl)! as URL)
        }
        
        ivProfileImage.clipsToBounds = true // обрізати картинку по рамкі
        ivProfileImage.layer.cornerRadius = 5 // заокруглити краї
        
        UIApplication.shared.statusBarStyle = .default
        
        // лого замість заголовку
        let logo = UIImage(named: "blue_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // автоматичне вираховування висоти ячейки
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        reloadData()
        
        // оновлення списку твітів по відтягуванню екрану вниз
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.reloadData), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

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
        cell.indexPath = indexPath as NSIndexPath
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    var reloadedIndexPath = [Int]()
    
    // метод для оновлення медіа
    func reloadTableCellAtIndex(cell: UITableViewCell, indexPath: NSIndexPath) {
        if (reloadedIndexPath.index(of: indexPath.row) == nil) {
            reloadedIndexPath.append(indexPath.row)
            tableView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
    }
    
    func reloadData(append: Bool = false) {
        TwitterClient.sharedInstance?.userTimeLine(user: user, maxId: !append ? nil : lastTweetId, success: { (tweets) in
            // при догрузкі приєдную нові твіти до тих що є
            if (append) {
                var cleaned = tweets
                if tweets.count > 0 {
                    cleaned.remove(at: 0)
                }
                
                if cleaned.count > 0 {
                    self.tweets?.append(contentsOf: cleaned)
                    self.tableView.reloadData()
                }
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }, failure: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (tweets != nil && (tweets?.count)! > 0) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetTreshold = scrollViewContentHeight - tableView.bounds.size.height  // порог до якого тягнути
            if scrollView.contentOffset.y > scrollOffsetTreshold && tableView.isDragging {
                reloadData(append: true)
            }
            
        }
    }
}








