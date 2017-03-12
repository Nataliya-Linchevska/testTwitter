//
//  PostTweetsViewController.swift
//  testTwitter
//
//  Created by user on 10.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class PostTweetsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var lblReplyScreenName: UILabel!
    @IBOutlet weak var tvInputText: UITextView!
    
    var tweetButton: UIButton!
    var replyToTweet: Tweet?
    
    var charCountLabelNormalTextColor = UIColor(colorLiteralRed: 136/255.0, green: 146/255.0, blue: 158/255.0, alpha: 1)
    var tweetButtonEnabledBackgroundColor = UIColor(colorLiteralRed: 29/255.0, green: 161/255.0, blue: 243/255.0, alpha: 1)
    var tweetButtonDesabledBackgroundColor = UIColor(colorLiteralRed: 240/255.0, green: 242/255.0, blue: 245/255.0, alpha: 1)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivProfileImage.setImageWith(User.currentUser?.profileUrl as! URL)
        ivProfileImage.layer.cornerRadius = 5
        
        tvInputText.delegate = self
        lblName.text = User.currentUser?.name as? String
        lblScreenName.text = "@" + (User.currentUser?.screenName as! String)
        
        // для lbl для підрахунку знаків
        let navigationBar = self.navigationController!.navigationBar
        
        let toolbarView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        tvInputText.inputAccessoryView = toolbarView
        
        // кнопка для поста
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let tweetButton = UIButton(frame: CGRect(x: screenWidth - 60 - 10, y: 10, width: 60, height: 30))
        tweetButton.backgroundColor = tweetButtonEnabledBackgroundColor
        tweetButton.layer.cornerRadius = 5
        tweetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        tweetButton.setTitle("Tweet", for: .normal)
        tweetButton.addTarget(self, action: "onTweetButton", for: .touchDown)
        toolbarView.addSubview(tweetButton)
        
//        if replyToTweet == nil {
//            print("not reply")
//            lblReplyScreenName.text = ""
//        } else {
//            lblReplyScreenName.isHidden = false
//            lblReplyScreenName.text = "@" + (replyToTweet!.screenName! as String) + ":"
//        }
    }
    
    func onTweetButton() {
        tvInputText.resignFirstResponder()
        var composedText = tvInputText.text
        let apiParams = NSMutableDictionary()
        apiParams["status"] = composedText
        TwitterClient.sharedInstance?.publishTweet(apiParam: apiParams, completion: { (newTweet, error) in
            if newTweet != nil {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What's new?" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "What's new?"
            textView.textColor = UIColor(colorLiteralRed: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
        }
    }
    
    func disableSending(invalid: Bool = false) {
        tweetButton.backgroundColor = UIColor.white
        tweetButton.isEnabled = false
        tweetButton.setTitleColor(tweetButtonDesabledBackgroundColor, for: UIControlState.normal)
        tweetButton.layer.borderWidth = 1
        tweetButton.layer.borderColor = tweetButtonDesabledBackgroundColor.cgColor
    }
    
    func enableSending() {
        tweetButton.backgroundColor = tweetButtonEnabledBackgroundColor
        tweetButton.isEnabled = true
        tweetButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        tweetButton.layer.borderWidth = 0
    }

}




















