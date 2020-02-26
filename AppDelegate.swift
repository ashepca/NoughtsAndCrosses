//
//  AppDelegate.swift
//  Noughts & Crosses
//
//  Created by Andrew Shepherd, Blue Oak Apps on 2018-02-23.
//  Copyright © 2018 Andrew Shepherd, Blue Oak Apps. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Sample AdMob app ID - ca-app-pub-3940256099942544/4411468910
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3529250513838673~4413310665")
        
        return true
    }
}

