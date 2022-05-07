//
//  HomeView.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI

struct HomeView: View {
  @ObservedObject var auth: Authentication
  
  var body: some View {
    VStack{
      if auth.uid == "" {
        AuthView(auth: auth)
      } else {
        MainTabView(auth: auth)
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
