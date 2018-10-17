//
//  AppDelegate.swift
//  TOCTest
//
//  Created by Karim on 14/10/2018.
//  Copyright © 2018 Karim. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Parse configuration & initialization
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = DataAccess.appId
            $0.clientKey = DataAccess.clientKey
            $0.server = DataAccess.serverUrl
        }
        
        Parse.initialize(with: configuration)
        
        return true
    }
}
