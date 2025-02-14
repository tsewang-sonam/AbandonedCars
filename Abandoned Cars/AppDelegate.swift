//
//  AppDelegate.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/12/24.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
//            print("Has Launched Before: \(hasLaunchedBefore)")
//
//            if hasLaunchedBefore {
//                    // If the app has been launched before, set the root view controller to the MainViewController
//                    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenuViewController")
//                    window?.rootViewController = mainVC
//                } else {
//                    // If it's the first launch, set the root view controller to the InitialViewController
//                    let initialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
//                    window?.rootViewController = initialVC
//                }
//
//                // Make the window visible
//                window?.makeKeyAndVisible()
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

