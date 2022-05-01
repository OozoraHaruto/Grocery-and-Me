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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    Firestore.firestore()
    return true
  }
}
