//
//  AppDelegate.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    Firestore.firestore()
    FirebaseConfiguration.shared.setLoggerLevel(.min)
    
    // Notification
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions
    ) { _, _ in }
    application.registerForRemoteNotifications()
    Messaging.messaging().delegate = self
    
    // Will be used everytime so init here will be faster
    CATEGORIES = [
      ItemCategory(icon: "wine-glass",
                   key: "CATEGORY_ALCOHOL"),
      ItemCategory(icon: "baby",
                   key: "CATEGORY_BABY"),
      ItemCategory(icon: "bread-loaf",
                   key: "CATEGORY_BAKERY"),
      ItemCategory(icon: "cup-straw",
                   key: "CATEGORY_BEVERAGES"),
      ItemCategory(icon: "pancakes",
                   key: "CATEGORY_BREAKFAST"),
      ItemCategory(icon: "shirt",
                   key: "CATEGORY_CLOTHES"),
      ItemCategory(icon: "can-food",
                   key: "CATEGORY_CANNED_FOOD"),
      ItemCategory(icon: "salt-shaker",
                   key: "CATEGORY_CONDIMENTS"),
      ItemCategory(icon: "cauldron",
                   key: "CATEGORY_COOKING"),
      ItemCategory(icon: "glass",
                   key: "CATEGORY_DAIRY"),
      ItemCategory(icon: "sausage",
                   key: "CATEGORY_DELI"),
      ItemCategory(icon: "ice-cream",
                   key: "CATEGORY_FROZEN"),
      ItemCategory(icon: "bowl-rice",
                   key: "CATEGORY_GRAINS"),
      ItemCategory(icon: "capsules",
                   key: "CATEGORY_HEALTH"),
      ItemCategory(icon: "toilet-paper-under",
                   key: "CATEGORY_HOUSEHOLD"),
      ItemCategory(icon: "meat",
                   key: "CATEGORY_MEAT"),
      ItemCategory(icon: "dog-leashed",
                   key: "CATEGORY_PET"),
      ItemCategory(icon: "apple-whole",
                   key: "CATEGORY_PRODUCE"),
      ItemCategory(icon: "fish",
                   key: "CATEGORY_SEAFOOD"),
      ItemCategory(icon: "cookie-bite",
                   key: "CATEGORY_SNACKS"),
    ]
    CATEGORIES = CATEGORIES.sorted(by: { $0.name < $1.name })
    CATEGORIES.append(
      ItemCategory(icon: "cubes-stacked",
                   key: "CATEGORY_OTHER")
    )
    CATEGORIES_DICT.reserveCapacity(CATEGORIES.count)
    for category in CATEGORIES {
      CATEGORIES_DICT[category.key] = category
    }
    
    return true
  }
}

// MARK: - Notification
// https://firebase.google.com/docs/cloud-messaging/ios/receive?authuser=0

extension AppDelegate: UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
    print(userInfo)
    Messaging.messaging().appDidReceiveMessage(userInfo)

    completionHandler(.noData)
  }
  
  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print(userInfo)
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    completionHandler([[.banner, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print(userInfo)
    Messaging.messaging().appDidReceiveMessage(userInfo)
    
    completionHandler()
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  private func process(_ notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    UIApplication.shared.applicationIconBadgeNumber = 0
    Messaging.messaging().appDidReceiveMessage(userInfo)
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging,
                 didReceiveRegistrationToken fcmToken: String?) {
    let tokenDict = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}
