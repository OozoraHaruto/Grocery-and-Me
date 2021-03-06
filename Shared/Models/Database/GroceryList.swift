//
//  GroceryList.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import SwiftUI
import FirebaseFirestore

/**
  Structure of Grocery list
 
  - important: most value that is optional are generated later and added
  later in (mostly in `ListsObv`)
 
  **Variables**
 
  `id` The ID of the Grocery List
 
  `name` The name of the Grocery List
 
  `icon` The name of the Grocery List (url)
 
  `color` The color of the Grocery List (Hexadecimal)
 
  `creator` The creator of the Grocery List
 
  `creatorObj` The creator of the Grocery List (`User` obj)
 
  `sharedToUsers` The list of users the Grocery List is shared with
 
  `sharedToUsersObj` The list of users the Grocery List is shared with (`[User]` obj)
 
  `sharedWithCurrentUser` Check if the list is shared with the current user
 */
public struct GroceryList: Codable, Hashable {
  var id: String? = ""
  let name: String
  let icon: String
  let color: String
  let creator: DocumentReference
  var creatorObj: User?
  let sharedToUsers: [DocumentReference]
  var sharedToUsersObj: [User]? = []
  var sharedWithCurrentUser: Bool? = false
  
  /**
    Use to remove data that we only use for FE
   
    - returns:
      A dictionary of data that do not contain data we do not need
   */
  func getCleanDictionary() -> [String: Any] {
    return [
      "name" : name,
      "icon": icon,
      "color": color,
      "creator": creator,
      "sharedToUsers": sharedToUsers
    ]
  }
  
  func getColor() -> Color {
    return getListColor(color: self.color)
  }
}
