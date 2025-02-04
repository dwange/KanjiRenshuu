//
//  AppDelegate.swift
//  KanjiRenshuu
//
//  Created by  Katya Savina on 21.01.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)

        if let window = window {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [ViewController()]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }

        return true
    }
    
}

