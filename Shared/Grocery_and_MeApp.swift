//
//  Grocery_and_MeApp.swift
//  Shared
//
//  Created by 春音 on 16/4/22.
//

import Firebase
import FirebaseCore
import FirebaseFirestore
import SwiftToast
import SwiftUI

@main
struct Grocery_and_MeApp: App {
#if os(iOS)
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#elseif os(macOS)
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
  @StateObject var auth = Authentication()

  init() {
    FirebaseApp.configure()
    Firestore.firestore()
    FirebaseConfiguration.shared.setLoggerLevel(.min)
  }

  var body: some Scene {
    WindowGroup {
      HomeView(auth: auth)
#if os(iOS)
      .navigationViewStyle(.stack)
#endif
      .modifier(ToastModifier())
      .environmentObject(AppDelegate.toastCoordinator)
    }
  }
}
