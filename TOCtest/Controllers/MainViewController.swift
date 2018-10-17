//
//  LoginViewController.swift
//  TOCTest
//
//  Created by Karim on 14/10/2018.
//  Copyright © 2018 Karim. All rights reserved.
//

import UIKit
import Parse
import SSSpinnerButton

class MainViewController: UIViewController {

    @IBOutlet weak var splashImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Splash background image
        
        splashImage.image = UIImage(named: "SplashScreen.jpg")
        
        // Check if current user exist
        
        let currentUser = PFUser.current()
        if currentUser != nil {
            
            // if user -> update events and go to HomeViewController
            DataAccess.shared.getEventRequest { (eventExist) in

                if eventExist {
                    self.performSegue(withIdentifier: "gotoHomeView", sender: nil)
                } else {
                    // NO EVENT
                }
            }
            
        } else {
            
            // if not -> go to LoginViewController
            perform(#selector(pushToLogin), with: nil, afterDelay: 2)
        }
    }
    
    @objc public func pushToLogin(){
        self.performSegue(withIdentifier: "gotoLoginView", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



