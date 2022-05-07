//
//  Authentication.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import FirebaseAuth
import FirebaseFirestore

class Authentication: ObservableObject {
  var handle: AuthStateDidChangeListenerHandle? = nil
  @Published var uid: String = ""
  @Published var name: String? = ""
  @Published var email: String? = ""
  @Published var photoURL: String? = ""
  var registering = false
  
  init() {
    listen()
  }
  
  /**
    Method to used to create test data for UI
   
    - parameters:
      - loggedIn: If the user is logged in
   
    - returns: Nothing
   */
  init(loggedIn: Bool) {
    if (loggedIn) {
      uid = "asdasd"
      name = "テスト"
      email = "test@test.com"
      photoURL = "https://pbs.twimg.com/media/ESW5EbQU4AAGTlV?format=jpg&name=large"
    } else {
      uid = ""
      name = ""
      email = ""
      photoURL = ""
    }
  }
  
  deinit {
    stopListen()
  }

  func listen() {
    if handle == nil {
      handle = Auth.auth().addStateDidChangeListener { [unowned self] (auth, user) in
        if let user = user, !registering {
          print("User logged in: \(user.uid)")
          subscribe(to: "\(COL_USERS).\(user.uid)")
          self.uid = user.uid
          self.email = user.email
          if [self.name, self.photoURL].anyNil() {
            // Get from firestore
            let db = Firestore.firestore()
            db.collection(COL_USERS).document(user.uid).getDocument(as: User.self) { result in
              switch result {
              case .success(let dbUser):
                self.name = dbUser.name
                self.photoURL = dbUser.profileImageLink
                
                // Save to auth
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = dbUser.name
                changeRequest.photoURL = URL(string: dbUser.profileImageLink)
                changeRequest.commitChanges { err in
                  if let err = err {
                    print("Error updating user: \(err)")
                    return
                  }
                }
                break
              case .failure(let error):
                print("Error decoding user: \(error)")
              }
            }
          }else {
            self.name = user.displayName
            self.photoURL = user.photoURL?.absoluteString
          }
        } else {
          if self.uid != "" {
            unsubscribe(from: "\(COL_USERS).\(self.uid)")
          }
          self.uid = ""
          self.name = ""
          self.email = ""
          self.photoURL = ""
        }
      }
    }
  }

  func stopListen() {
    if let handle = handle {
      Auth.auth().removeStateDidChangeListener(handle)
    }
  }
  
  func signout(completion:@escaping (NSError?) -> Void = { _ in }) {
    do {
      try Auth.auth().signOut()
      completion(nil)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
      completion(signOutError)
    }
  }
}
