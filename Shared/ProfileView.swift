//
//  ProfileView.swift
//  Grocery and Me
//
//  Created by 春音 on 17/4/22.
//

import SwiftUI
import SwiftMessages
import FirebaseAuth

struct ProfileView: View {
  @ObservedObject var auth: Authentication
  @State var reAuth: Bool = false
  
  var body: some View {
    VStack(alignment: .center, spacing: PADDING_STACK) {
      AsyncImage(url: URL(string: auth.photoURL!)) { phase in
        if let image = phase.image {
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: ICON_HEIGHT_PROFILE, height: ICON_HEIGHT_PROFILE)
            .cornerRadius(BORDER_RADIUS_ICON_PROFILE)
        } else if phase.error != nil {
          FontAwesomeSVG(svgName: "binary-slash",
                         frameHeight: ICON_HEIGHT_PROFILE,
                         color: UIColor.red.cgColor,
                         actAsSolid: false)
        } else {
          ProgressView()
        }
      }
      .frame(width: ICON_HEIGHT_PROFILE, height: ICON_HEIGHT_PROFILE)
      
      Text(auth.name!)
        .font(.largeTitle)
      
      Text(auth.email!)
        .font(.body)
      
      List {
        Section{
          Button{
            logout()
          } label: {
            Text("LOGOUT")
          }
        }
        
        Section {
          Button{
            deleteAccount()
          } label: {
            Text("DELETE_ACCOUNT")
              .font(.body)
              .foregroundColor(.red)
          }
        }
      }
      .listStyle(GroupedListStyle())
      
    }.sheet(isPresented: $reAuth) {
      AuthView(auth: auth,
               name: "",
               email: auth.email!,
               password: "",
               loading: false,
               loggingIn: true,
               loginBlock: { success in
        reAuth = !success
        deleteAccount()
      })
    }
  }
  
  private func logout() {
    auth.signout() { err in
      if let err = err {
        let errorView = getSwiftMessageBasicView(layout: .statusLine, theme: .error)
        errorView.bodyLabel?.text = err.localizedDescription
        SwiftMessages.show(config: getSwiftMessageStatusLineConfig(), view: errorView)
      }
    }
  }
  
  private func deleteAccount() {
    Auth.auth().currentUser?.delete { error in
      if let error = error as NSError? {
        print("Error deleting user: \(error.localizedDescription)")
        
        if error.code == 17014 {
          reAuth = true
        }
      }
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(auth: Authentication(loggedIn: true))
      .environment(\.locale, .init(identifier: "ja"))
  }
}
