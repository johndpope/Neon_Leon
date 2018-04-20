//
//  AppDelegate.swift
//  Neon Leon
//
//  Created by BDabrowski on 4/16/17.
//  Copyright © 2017 BD Creative. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds
import SwiftyStoreKit
import UserNotifications
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let pushNotifications = PushNotifications.shared


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //Be sure to make sure the code is the same here and SwiftyAd.swift.
        SwiftyAd.shared.setup(
            withBannerID: "ca-app-pub-1397382354626971/3371077102", //"ca-app-pub-1397382354626971/3371077102",
            interstitialID: "ca-app-pub-1397382354626971/2613363359", //"ca-app-pub-1397382354626971/2613363359",
            rewardedVideoID: ""
        )
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        self.pushNotifications.start(instanceId: "0aa1eb0f-eb63-42e9-8869-f9040ad044e6")
        self.pushNotifications.registerForRemoteNotifications()
        //registerForPushNotifications()
        
        return true
    }
    
    /*func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }*/
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
            self.pushNotifications.registerDeviceToken(deviceToken) {
            try? self.pushNotifications.subscribe(interest: "hello")
        
        /*let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")*/
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        //print("Failed to register: \(error)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  }
}

