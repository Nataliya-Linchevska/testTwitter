//
//  SplashViewController.swift
//  testTwitter
//
//  Created by user on 06.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, TwitterLoginDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!appDelegate.splashDelay) {
            appDelegate.delay(1.0, closure: {
                self.continueLogin()
            })
        }
    }
    
    func goToLogin() {
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    func continueLogin() {
        appDelegate.splashDelay = false
        self.goToLogin()
    }
}
