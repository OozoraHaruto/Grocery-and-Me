//
//  Grocery_and_MeApp.swift
//  Shared
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI

@main
struct Grocery_and_MeApp: App {
  #if os(macOS)
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  #else
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  #endif
  
  @StateObject var auth = Authentication()
  
  var body: some Scene {
    WindowGroup {
      #if os(macOS)
      HomeView(auth: auth)
      #else
      HomeView(auth: auth)
        .navigationViewStyle(.stack)
      #endif
    }
  }
}
