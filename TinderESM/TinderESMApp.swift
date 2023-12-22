//
//  TinderESMApp.swift
//  TinderESM
//
//  Created by Yuki Inui on 2023/09/24.
//

import SwiftUI
import UIKit
// import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
struct TinderESMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("granted: \(granted)")
            print("error: \(error?.localizedDescription ?? "")")
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        //FirebaseApp.configure()


        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map({String(format: "%02x", $0)}).joined()
        
        print("deviceToken: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceId")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
}
