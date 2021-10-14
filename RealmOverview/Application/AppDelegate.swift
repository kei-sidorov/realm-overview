//
//  AppDelegate.swift
//  RealmOverview
//
//  Created by Kirill Sidorov on 19.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var rootCoordinator: TabBarCoordinator!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let productStorage = ProductStorage()
        let orderStorage = OrderStorage()
        let tagStorage = TagStorage()
        
        rootCoordinator = TabBarCoordinator(
            productStorage: productStorage,
            orderStorage: orderStorage,
            tagStorage: tagStorage
        )
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootCoordinator.rootController
        window?.makeKeyAndVisible()
        
        rootCoordinator.start()
        
        return true
    }
}

