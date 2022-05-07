//
//  CustomTabView.swift
//  Grocery and Me
//
//  Created by 春音 on 17/4/22.
//  Referenced https://truongvankien.medium.com/custom-tabview-in-swiftui-e7c0bf5667ab
//

import SwiftUI

struct CustomTabView<Content: View>: View {
  @ObservedObject var navBarObserver: NavBarObv
  let tabs: [TabItemData]
  @Binding var selectedIndex: Int
  @ViewBuilder let content: (Int) -> Content
  
  var body: some View {
    ZStack {
      TabView(selection: $selectedIndex) {
        ForEach(0 ..< tabs.count, id: \.self) { index in
          content(index)
            .tag(index)
        }
      }
      
      if navBarObserver.showNavBar {
        VStack {
          Spacer()
          TabBottomView(tabbarItems: tabs, selectedIndex: $selectedIndex)
        }.padding(.bottom, 8)
      }
    }
  }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
      CustomTabView(navBarObserver: NavBarObv(), tabs: TabType.allCases.map({ $0.tabItem }), selectedIndex: .constant(0)) { index in
        EmptyView()
      }
    }
}
