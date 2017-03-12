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
        
        // градієнт фону
        let color1 = UIColor(colorLiteralRed: 42.0/255.0, green: 163.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let color2 = UIColor(colorLiteralRed: 88.0/255.0, green: 178.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        let color3 = UIColor(colorLiteralRed: 141.0/255.0, green: 192.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        let color4 = UIColor(colorLiteralRed: 224.0/255.0, green: 226.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        
        let gradientLocations: [Float] = [0.0, 0.25, 0.75, 1.0]
        let gradientColor: [CGColor] = [color1.cgColor, color2.cgColor, color3.cgColor, color4.cgColor]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        // анімація кнопок
        buttonContainerView.layer.cornerRadius = 5 //заокруглення кнопки
        buttonContainerView.alpha = 0
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // вмикаю-вимикаю необхідні констрейнти
        logoVerticalConstraint.isActive = false
        logoMovedToTopConstraint.isActive = true
        
        logoHeightOriginalConstraint.isActive = false
        logoHeightSmallerConstraint.isActive = true
        
        // анімація logo
        UIView.animate(withDuration: 1.0) {
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
    
    @IBAction func btnLogin() {
        TwitterClient.sharedInstance?.login(success: {
            print("Logget In")
            self.dismiss(animated: true, completion: {
            })
        }, failure: { (error) in
            print(error)
        })
    }

    
    
    
    
    
    
    
    
}
