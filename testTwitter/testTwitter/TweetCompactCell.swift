//
//  TweetCompactCell.swift
//  testTwitter
//
//  Created by user on 09.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class TweetCompactCell: TweetCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    override func tweetSetConfigure() {
        super.tweetSetConfigure()
        lblRetweetCount.text = tweet.retweetsCount > 0 ? String(tweet.retweetsCount) : ""
        lblFavoriteCount.text = tweet.favoritesCount > 0 ? String(tweet.favoritesCount): ""
    }
}
