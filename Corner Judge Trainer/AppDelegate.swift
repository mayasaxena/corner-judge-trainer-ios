//
//  AppDelegate.swift
//  Corner Judge Trainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let joinMatchViewController = JoinMatchViewController()
        let navigationController = UINavigationController(rootViewController: joinMatchViewController)

        navigationController.navigationBar.barTintColor = UIColor.flatWhite
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.backgroundColor = UIColor.clear
        navigationController.navigationBar.shadowImage = UIImage()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return true
    }
}
