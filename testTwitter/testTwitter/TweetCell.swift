//
//  TweetCell.swift
//  testTwitter
//
//  Created by user on 08.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var ivProfilePicture: UIImageView!
    @IBOutlet weak var lblAuthorName: UILabel!
    @IBOutlet weak var lblAuthorScreenName: UILabel!
    @IBOutlet weak var lblTweetContents: UILabel!
    @IBOutlet weak var lblTweetAge: UILabel!
    @IBOutlet weak var lblRetweetCount: UILabel!
    @IBOutlet weak var lblFavoriteCount: UILabel!
    @IBOutlet weak var btnRetweet: DOFavoriteButton!
    @IBOutlet weak var btnFavorite: DOFavoriteButton!
    @IBOutlet weak var ivMediaImage: UIImageView!
    
    var tweetID: NSNumber!

    var tweet: Tweet! {
        didSet {
            tweetSetConfigure()
        }
    }
    
    func tweetSetConfigure() {
        tweetID = tweet.tweetID
        
        ivProfilePicture.setImageWith(tweet.authorProfilePicURL as! URL)
        // заокрюглюю края аватарки
        ivProfilePicture.layer.cornerRadius = 5
        ivProfilePicture.clipsToBounds = true
        
        lblAuthorName.text = tweet.text as? String
        lblAuthorScreenName.text = "@" + (tweet.author as! String)
        lblTweetContents.text = tweet.text as? String
        
        btnRetweet.isSelected = tweet.retweeted
        btnFavorite.isSelected = tweet.favorited
        
        ivMediaImage.image = nil
    }
    
    @IBAction func onRetweetButton(sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
            tweet.retweeted = false
            lblRetweetCount.text = String(tweet.retweetsCount) ?? ""
        } else {
            sender.select()
            tweet.retweeted = true
            lblRetweetCount.text = String(tweet.retweetsCount) ?? ""
        }
    }
    
    @IBAction func onFavoriteButton(sender: DOFavoriteButton) {
        if sender.isSelected {
            sender.deselect()
            tweet.favorited = false
            lblFavoriteCount.text = String(tweet.favoritesCount) ?? ""
        } else {
            sender.select()
            tweet.favorited = true
            lblFavoriteCount.text = String(tweet.favoritesCount) ?? ""
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
