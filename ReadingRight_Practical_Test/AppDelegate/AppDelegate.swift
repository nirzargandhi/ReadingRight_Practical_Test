//
//  AppDelegate.swift
//  ReadingRight_Practical_Test
//
//  Created by Nirzar Gandhi on 01/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Variable Declaration
    var window: UIWindow?
    var navhomeViewController : UINavigationController?
    let notificationDelegate = NotificationDelegate()
    var backgroundUpdateTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    //MARK: - AppDelegate Methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !isKeyPresentInUserDefaults(key: UserDefault.kIsKeyChain) {
            userDefaultKeyChainDataClear()
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        Utility().setRootTabbarVC()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        UIPasteboard.general.items = [[String: Any]()]
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

