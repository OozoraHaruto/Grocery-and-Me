//
//  MainTabView.swift
//  Grocery and Me
//
//  Created by 春音 on 17/4/22.
//  Referenced https://truongvankien.medium.com/custom-tabview-in-swiftui-e7c0bf5667ab
//

import SwiftUI

struct MainTabView: View {
  @ObservedObject var auth: Authentication
  @State var selectedIndex: Int = 0
  
  var body: some View {
    CustomTabView(tabs: TabType.allCases.map({ $0.tabItem }), selectedIndex: $selectedIndex) { index in
      let type = TabType(rawValue: index) ?? .list
      getTabView(type: type)
    }
  }
  
  @ViewBuilder
  func getTabView(type: TabType) -> some View {
    switch type {
    case .list:
      ListSelectionView(auth: auth)
    case .profile:
      ProfileView(auth: auth)
    case .settings:
      SettingsView()
    }
  }
}

struct MainTabView_Previews: PreviewProvider {
  static var previews: some View {
    MainTabView(auth: Authentication(loggedIn: true))
  }
}
