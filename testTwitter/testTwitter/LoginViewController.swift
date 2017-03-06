//
//  LoginViewController.swift
//  testTwitter
//
//  Created by user on 06.03.17.
//  Copyright © 2017 GeekHub. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoMovedToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightOriginalConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightSmallerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var buttonContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // вмикаю-вимикаю необхідні констрейнти
        logoVerticalConstraint.isActive = false
        logoMovedToTopConstraint.isActive = true
        
        logoHeightOriginalConstraint.isActive = false
        logoHeightSmallerConstraint.isActive = true
        
        // анімація logo
        UIView.animate(withDuration: 1.5) {
            // обновляю констрейнти
            self.view.layoutIfNeeded()
            
            self.buttonContainerView.alpha = 1
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
            
            self.buttonContainerView.frame = self.buttonContainerView.frame.offsetBy(dx: 0, dy: -20)
            self.titleLabel.frame = self.titleLabel.frame.offsetBy(dx: 0, dy: -20)
            self.subtitleLabel.frame = self.subtitleLabel.frame.offsetBy(dx: 0, dy: -20)            
        }
        
    }

    
    
    
    
    
    
    
    
}
