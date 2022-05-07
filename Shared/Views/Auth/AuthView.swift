//
//  AuthView.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftMessages

struct AuthView: View {
  @ObservedObject var auth: Authentication
  
  @State var name: String = ""
  @State var email: String = (UserDefaults.standard.string(forKey: DEF_LOGIN_EMAIL) ?? "")
  @State var password: String = ""
  @State var loading = false
  @State var loggingIn = true
  
  var loginBlock: (Bool) -> Void = { _ in }
  
  var body: some View {
    ZStack{
      HStack(alignment: .center, spacing: PADDING_STACK) {
        Spacer()
        VStack(alignment: .center, spacing: PADDING_STACK) {
          // logo
          Image("ListImage")
            .resizable()
            .frame(width: 200, height: 200)
            .aspectRatio(contentMode: .fit)
            .padding(.top, 100)
            .padding(.bottom, 50)
            
          
          // Input boxes
          if (!loggingIn) {
            TextField("NAME", text: $name)
              .textFieldStyle(BottomLineTextFieldStyle())
              .font(.body)
              .keyboardType(.default)
          }
          TextField("EMAIL", text: $email)
            .textFieldStyle(BottomLineTextFieldStyle())
            .font(.body)
            .keyboardType(.emailAddress)
          SecureField("PASSWORD", text: $password)
            .font(.body)
            .textFieldStyle(BottomLineTextFieldStyle())
          
          // Action buttons
          Button{
            loginOrSignUp(name, email, password, loggingIn)
          } label: {
            Label{
              Text(loggingIn ? "LOGIN": "SIGNUP")
                .font(.body)
                .foregroundColor(Color.white)
                .padding(PADDING_BUTTON_AUTH)
            } icon: {
              if (loggingIn) {
                FontAwesomeSVG(svgName: "right-to-bracket",
                               frameHeight: ICON_HEIGHT_BUTTON,
                               color: UIColor.white.cgColor,
                               actAsSolid: true)
                  .frame(width: ICON_HEIGHT_BUTTON, height: ICON_HEIGHT_BUTTON, alignment: .center)
              } else {
                FontAwesomeSVG(svgName: "user-plus",
                               frameHeight: ICON_HEIGHT_BUTTON,
                               color: UIColor.white.cgColor,
                               swapColor: true,
                               actAsSolid: true)
                  .frame(width: ICON_HEIGHT_BUTTON, height: ICON_HEIGHT_BUTTON, alignment: .center)
              }
            }
              .frame(minWidth: 0, maxWidth: .infinity)
              .background(Color.bootBlue)
              .cornerRadius(BORDER_RADIUS_BUTTON_AUTH)
          }.disabled(loading)
          
          HStack{
            Button{
              loggingIn = !loggingIn
            } label: {
              Text(loggingIn ? "AUTH_NO_ACCOUNT" : "AUTH_HAVE_ACCOUNT")
                .font(.body)
            }
            Spacer()
          }
          
          Spacer()
        }
        Spacer()
      }
      
      if (loading){
        ProgressFullPageView()
      }
    }
  }
  
  private func loginOrSignUp(_ name: String, _ email: String, _ password: String, _ loggingIn: Bool) {
    if (loggingIn) {
      login(email: email, password: password, completionHandler: loginBlock)
    } else {
      signup(email: email, password: password, name: name)
    }
  }
  
  private func signup(email: String, password: String, name: String) {
    loading = true
    auth.registering = true
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if error != nil {
        let errorView = getSwiftMessageBasicView(layout: .statusLine, theme: .error)
        errorView.bodyLabel?.text = error?.localizedDescription
        SwiftMessages.show(config: getSwiftMessageStatusLineConfig(), view: errorView)
      } else if let user = authResult?.user {
        // User Object
        let newUser = User(id: user.uid, name: name, email: email.lowercased())
        
        // Save to FireStorage
        let db = Firestore.firestore()
        db.collection(COL_USERS).document(newUser.id).setData(newUser.dictionary) { err in
          if let err = err {
            print("Error adding document: \(err)")
            failedToRegister()
          } else {
            // Save to Google Auth
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
              changeRequest.displayName = name
              changeRequest.photoURL = URL(string: newUser.profileImageLink)
              changeRequest.commitChanges { err in
                if let err = err {
                  print("Error updating user: \(err)")
                  failedToRegister()
                  return
                } else {
                  // Sign out user
                  auth.signout()
                  
                  // prompt sign up success
                  let successView = getSwiftMessageBasicView(layout: .centeredView, theme: .success)
                  successView.titleLabel?.text = "SIGNUP_SUCCESS_TITLE".localized
                  successView.bodyLabel?.text = "SIGNUP_SUCCESS_DESC".localized
                  SwiftMessages.show(config: getSwiftMessageStatusLineConfig(), view: successView)
                  
                  // Bring user to login page
                  self.loggingIn = true
                  self.loading = false
                  self.password = ""
                }
              }
            } else {
              failedToRegister()
            }
          }
        }
      }
    }
  }
  
  private func failedToRegister() {
    // Sign out user
    auth.signout()
    
    Auth.auth().currentUser?.delete { error in
      if let error = error {
        print("Error deleting user: \(error)")
        
        self.loading = false
      }
    }
  }
  
  private func login(email: String, password: String, completionHandler:@escaping (Bool) -> Void) {
    loading = true
    auth.registering = false
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      loading = false
      if error != nil {
        let errorView = getSwiftMessageBasicView(layout: .statusLine, theme: .error)
        errorView.bodyLabel?.text = error?.localizedDescription
        SwiftMessages.show(config: getSwiftMessageStatusLineConfig(), view: errorView)
      } else {
        UserDefaults.standard.set(email, forKey: DEF_LOGIN_EMAIL)
      }
      completionHandler(error == nil)
    }
  }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
      AuthView(auth: Authentication(loggedIn: false))
        .environment(\.locale, .init(identifier: "ja"))
      AuthView(auth:Authentication(loggedIn: false), email: "", password: "", loading: true, loggingIn: false)
        .environment(\.locale, .init(identifier: "ja"))
    }
}
