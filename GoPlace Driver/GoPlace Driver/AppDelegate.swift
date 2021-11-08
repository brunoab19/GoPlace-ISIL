//
//  AppDelegate.swift
//  GoPlace Driver
//
//  Created by Bruno Aburto on 31/10/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let options = FirebaseOptions(googleAppID: "1:6647150114:ios:a5a53bf58c6f8d9458fc7b",
                                      gcmSenderID: "6647150114")
        options.apiKey = "AIzaSyCf9XLqNNlSnYWwmb1e693_1dZ0DXF_4ik"
        options.projectID = "pe-isil-goplace"
        options.storageBucket = "pe-isil-goplace.appspot.com"
        FirebaseApp.configure(options: options)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

