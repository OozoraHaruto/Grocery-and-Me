//
//  HomeView.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var auth: Authentication
  @StateObject var navBarObserver: NavBarObv = NavBarObv()

#if canImport(UIKit)
  @State private var section: MenuItems? = .list
#else
  @State private var section: MenuItems = .list
#endif

  var body: some View {
    VStack{
      if auth.uid == "" {
        AuthView(auth: auth)
      } else {
        NavigationSplitView {
          List(selection: $section){
            Section {
              NavigationLink(value: MenuItems.list) {
                Label {
                  Text("TAB_LISTS")
                } icon: {
                  Image(systemName: "list.bullet.clipboard")
                    .foregroundStyle(Color.bootBlue)
                }
              }
            }

            Section {
              NavigationLink(value: MenuItems.profile) {
                Label {
                  Text("TAB_PROFILE")
                } icon: {
                  AsyncImage(url: URL(string: auth.photoURL!)) { phase in
                    if let image = phase.image {
                      image
                        .resizable()
                        .frame(width: ICON_HEIGHT_HOME_TAB, height: ICON_HEIGHT_HOME_TAB)
                        .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                      FontAwesomeSVG(svgName: "binary-slash",
                                     frameHeight: ICON_HEIGHT_HOME_TAB,
                                     color: Color.red.getCGColor(),
                                     actAsSolid: false)
                    } else {
                      ProgressView()
                    }
                  }
                  .clipShape(Circle())
                }
              }
              
              NavigationLink(value: MenuItems.settings) {
                Label {
                  Text("TAB_SETTINGS")
                } icon: {
                  Image(systemName: "gear")
                    .foregroundStyle(Color.bootBlue)
                }
              }
            }
          }
          .navigationTitle("MENU")
#if os(iOS)
          .listStyle(.insetGrouped)
#endif
        } detail: {
          NavigationStack {
            switch section {
            case .list: ListSelectionView(auth: auth,
                                          navBarObserver: navBarObserver)
            case .profile: ProfileView(auth: auth)
            case .settings: SettingsView()
  #if canImport(UIKit)
            case .none: EmptyView()
  #endif
            }
          }
        }
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(auth: Authentication(loggedIn: true))
    HomeView(auth: Authentication(loggedIn: false))
  }
}
