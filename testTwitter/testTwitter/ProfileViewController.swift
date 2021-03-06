//
//  ProfileViewController.swift
//  testTwitter
//
//  Created by user on 11.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwitterTableViewDelegate, AnimatedImage {
    
    
    @IBOutlet weak var ivBackgroundImage: UIImageView!
    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    @IBOutlet weak var ivProfileImageBackground2: UIImageView!
    @IBOutlet weak var ivProfileImageBackground1: UIImageView!
    @IBOutlet weak var shadowLineView: UIView!
    
    
    
    //для збільшення картинки
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    var statusImageView: UIImageView?
    
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
        // полоска тіні
        let shadowLine = CAGradientLayer()
        shadowLine.frame = shadowLineView.bounds
        let topColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        let bottomColor = UIColor(white: 0, alpha: 0.0).cgColor
        shadowLine.colors = [topColor, bottomColor]
        shadowLine.locations = [0.0, 1.0]
        self.shadowLineView.layer.addSublayer(shadowLine)
        
//         рамка навколо фото
        let ProfileImageBackground2 = CAGradientLayer()
        ProfileImageBackground2.frame = ivProfileImageBackground2.bounds
        let topColor2 = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        let bottomColor2 = UIColor(white: 1, alpha: 1.0).cgColor
        ProfileImageBackground2.colors = [bottomColor2, bottomColor2]
        ProfileImageBackground2.locations = [0.0, 1.0]
        self.ivProfileImageBackground2.layer.addSublayer(ProfileImageBackground2)
        ivProfileImageBackground2.clipsToBounds = true // обрізати картинку по рамкі
        ivProfileImageBackground2.layer.cornerRadius = 7 // заокруглити краї
//        
//        ivProfileImage.layer.shadowColor = UIColor.black.cgColor
//        ivProfileImage.layer.shadowOpacity = 1
//        ivProfileImage.layer.shadowOffset = CGSize.zero
//        ivProfileImage.layer.shadowRadius = 10
        
        let ProfileImageBackground1 = CAGradientLayer()
        ProfileImageBackground1.frame = ivProfileImageBackground1.bounds
        ProfileImageBackground1.colors = [topColor2, topColor2]
        ProfileImageBackground1.locations = [0.0, 1.0]
        self.ivProfileImageBackground1.layer.addSublayer(ProfileImageBackground1)
        ivProfileImageBackground1.clipsToBounds = true // обрізати картинку по рамкі
        ivProfileImageBackground1.layer.cornerRadius = 8 // заокруглити краї

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
        let logo = UIImage(named: "blue_logo")?.withRenderingMode(.alwaysTemplate)
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
        cell.parentControllerForZoomingImage = self
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
    
    // анімація збільшення картинки
    func animateImageView(_ statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            if let keyWindow = UIApplication.shared.keyWindow { //головне вікно приложухи
                keyWindow.addSubview(navBarCoverView)
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HomeViewController.zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
            }, completion: nil)
        }
    }
    
    // анімація зменшення картинки
    func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
            }, completion: { (didComplete) -> Void in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            })
        }
    }
}








