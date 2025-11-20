//
//  AppDelegate.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 21.01.2025.
//

import UIKit
import Firebase
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if Auth.auth().currentUser != nil {
            window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: AuthViewController())
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

