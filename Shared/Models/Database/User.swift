//
//  User.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import FirebaseFirestore

/**
  Structure of User
 
  - important: We use auth by firebase so auth will not be saved here.
  `email` and `profileImageLink` here are backups. Update both here and auth if changed.
 
  **Variables**
 
  `id` The ID of the user (`uid` in auth)
 
  `name` The name of the user (`displayName` in auth)
 
  `email` The email of the user (`email` in auth)
 
  `profileImage` The email hash of the user
 
  `profileImageLink` combination of hash and link from gravatar (`photoURL` in auth)
 */
public struct User: Codable, Hashable {
  let id: String
  let name: String
  let email: String
  let profileImage: String
  let profileImageLink: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case profileImage
    case profileImageLink
  }
  
  init(id: String, name: String, email:String){
    self.id = id
    self.name = name
    self.email = email
    let emailMD5 = email.lowercased().MD5
    self.profileImage = emailMD5
    self.profileImageLink = generatePicLink(emailMD5)
  }
  
  init(id: String, name: String, email:String, profileImage: String){
    self.id = id
    self.name = name
    self.email = email
    self.profileImage = profileImage
    self.profileImageLink = generatePicLink(profileImage)
  }
  
  func getDbBRef() -> DocumentReference {
    return Firestore.firestore().document(String(format: "%@/%@", COL_USERS, id))
  }
}
