//
//  ItemCategory.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

/**
  Structure of Item Category
 
  **Variables**

  `name` The name of the category (localized)

  `icon` The icon for the category

  `key` The localization key of the item name
 */
public struct ItemCategory: Hashable {
  let name: String
  let icon: String
  let key: String
  
  init(icon: String, key: String) {
    self.name = key.localized
    self.icon = icon
    self.key = key
  }
}
