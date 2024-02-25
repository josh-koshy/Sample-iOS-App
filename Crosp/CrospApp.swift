//
//  CrospApp.swift
//  Crosp
//
//  Created by Joshua Koshy on 12/27/23.
//  Copyright © 2024 Joshua Koshy. All rights reserved.
//

import SwiftUI
import FirebaseCore
import Firebase

public class firebasetoken {
    public static var token = ""
}


class AppDelegate: UIResponder, UIApplicationDelegate{

    var firebaseToken: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
        
        FirebaseApp.configure()
        self.registerForFirebaseNotification(application: application)
        Messaging.messaging().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func registerForFirebaseNotification(application: UIApplication) {            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { granted, error in
                if let error = error {
                    print("Authorization error: \(error)")
                } else if !granted {
                    print("Permission denied by the user")
                }
        }
        application.registerForRemoteNotifications()
    }
    
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {

//MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            self.firebaseToken = token
            firebasetoken.token = token;
            print("Firebase token: \(token)")
        } else {
            print("Firebase token is nil")
        }
    }

    //UNUserNotificationCenterDelegate
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("APNs received with: \(userInfo)")
     }
}

@main
struct CrospApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreenView()
            }
        }
    }
}
