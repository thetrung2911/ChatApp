//
//  AppDelegate.swift
//  RimochaApp
//
//  Created by iMac dev4 on 8/27/20.
//  Copyright © 2020 vnc. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            
        }else{
            guard let window = self.window else { fatalError("No Window") }
            let storyboard = UIStoryboard(name: homeStoryboardName, bundle: nil)
            let nav = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: homeViewControllerIdentifier))
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

