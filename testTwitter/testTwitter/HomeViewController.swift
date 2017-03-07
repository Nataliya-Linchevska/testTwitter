//
//  HomeViewController.swift
//  testTwitter
//
//  Created by user on 07.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout() {
        TwitterClient.sharedInstance?.logout()
    }

}
