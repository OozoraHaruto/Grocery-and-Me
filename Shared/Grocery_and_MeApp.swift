//
//  Grocery_and_MeApp.swift
//  Shared
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI

@main
struct Grocery_and_MeApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @StateObject var auth = Authentication()
  
  var body: some Scene {
    WindowGroup {
      HomeView(auth: auth)
      .navigationViewStyle(.stack)
    }
  }
}
