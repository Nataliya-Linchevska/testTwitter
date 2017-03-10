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
    
    @IBOutlet weak var mediaImageVerticalSpasingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaImageHeightConstraint: NSLayoutConstraint!

    var tweetID: NSNumber!
    
    weak var delegate: TwitterTableViewDelegate?
    var indexPath: NSIndexPath!

    var tweet: Tweet! {
        didSet {
            tweetSetConfigure()
        }
    }
    
    func tweetSetConfigure() {
        tweetID = tweet.tweetID
        
        var tweetTextFontSize: CGFloat { get { return 15.0 } }
        var tweetTextWeight: CGFloat { get { return UIFontWeightRegular } }
        
        ivProfilePicture.setImageWith(tweet.authorProfilePicURL as! URL)
        // заокрюглюю края аватарки
        ivProfilePicture.layer.cornerRadius = 5
        ivProfilePicture.clipsToBounds = true
        
        lblAuthorName.text = tweet.author as? String
        lblAuthorScreenName.text = "@" + (tweet.screenName as! String)
        lblTweetContents.text = tweet.text as? String
        
        let urls = tweet.urls
        let media = tweet.media
        
        btnRetweet.isSelected = tweet.retweeted
        btnFavorite.isSelected = tweet.favorited
        
        ivMediaImage.image = nil
        
        var displayUrls = [String]()
        
        if let urls = urls {
            for url in urls {
                let urlText = url["url"] as! NSString
                lblTweetContents.text = lblTweetContents.text?.replace(target: urlText as String, withString: "")
                var displayUrl = url["display_url"] as! NSString
                if let expandedUrl = url["expanded_url"] {
                    displayUrl = expandedUrl as! NSString
                }
                displayUrls.append(displayUrl as String)
            }
        }
        
        // робота з висотою картинок в тексті твіта
        if let media = media {
            for medium in media {
                let urlText = medium["url"] as! String
                lblTweetContents.text = lblTweetContents.text?.replace(target: urlText, withString: "")
                
                if((medium["type"] as? String) == "photo") {
                    
                    mediaImageVerticalSpasingConstraint.constant = 8
                    ivMediaImage.isHidden = false

                    
                    let mediaUrl = medium["media_url_https"] as! String
                    if mediaImageHeightConstraint != nil {
                        mediaImageHeightConstraint.isActive = false
                    }
                    
                    ivMediaImage.layer.cornerRadius = 5
                    ivMediaImage.clipsToBounds = true

                    ivMediaImage.setImageWith(NSURLRequest(url: NSURL(string: mediaUrl)! as URL) as URLRequest, placeholderImage: nil, success: { (request, response, image) in
                        self.ivMediaImage.image = image
                        self.delegate?.reloadTableCellAtIndex(cell: self, indexPath: self.indexPath)
                        
                    }, failure: { (request, response, error) in
                        // error
                    })                    
                }
            }
        }
        
        
        
        
        if displayUrls.count > 0 {
            let content = lblTweetContents.text ?? ""
            let urlText = " " + displayUrls.joined(separator: " ")
            
            let text = NSMutableAttributedString(string: content)
            text.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: tweetTextFontSize, weight: tweetTextWeight), range: NSRange(location: 0, length: content.characters.count))
            
            let links = NSMutableAttributedString(string: urlText)
            links.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: tweetTextFontSize, weight: tweetTextWeight), range: NSRange(location: 0, length: urlText.characters.count))
            
            links.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 36.0/255.0, green: 144.0/255.0, blue: 212.0/255.0, alpha:1), range: NSRange(location: 0, length: urlText.characters.count))

            text.append(links)

            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.lineBreakMode = .byCharWrapping
            text.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: text.string.characters.count))
            
            lblTweetContents.attributedText = text
        }
        
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
