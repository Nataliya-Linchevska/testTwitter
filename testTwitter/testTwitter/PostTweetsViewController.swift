//
//  PostTweetsViewController.swift
//  testTwitter
//
//  Created by user on 10.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class PostTweetsViewController: UIViewController {

    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var lblReplyScreenName: UILabel!
    @IBOutlet weak var tvInputText: UITextView!
    
    var charCountLabel: UILabel!
    var tweetButton: UIButton!
    var replyToTweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }


}
