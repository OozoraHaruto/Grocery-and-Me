//
//  constants.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI

// MARK: - UI
// MARK: Padding
let PADDING_STACK:CGFloat = 10
let PADDING_TEXTFIELD:CGFloat = 5
let PADDING_BUTTON_AUTH:CGFloat = 10

// MARK: Border
let BORDER_BUTTON_AUTH: CGFloat = 1

// MARK: Radius
let BORDER_RADIUS_BUTTON_AUTH: CGFloat = 5
let BORDER_RADIUS_ICON_PROFILE: CGFloat = 100
let BORDER_RADIUS_ICON_LIST_INFO: CGFloat = 25

// MARK: - Icon
let ICON_HEIGHT_DEFAULT: CGFloat = 500
let ICON_HEIGHT_PROFILE: CGFloat = 200
let ICON_HEIGHT_HOME_TAB: CGFloat = 20
let ICON_HEIGHT_BUTTON: CGFloat = 20
let ICON_HEIGHT_LIST_CELL: CGFloat = 20
let ICON_HEIGHT_LIST_INFO: CGFloat = 200
let ICON_HEIGHT_ITEM_LIST_HEADER: CGFloat = 15

// MARK: Data
var CATEGORIES: [ItemCategory] = [] // set in delegate
var CATEGORIES_DICT: [String: ItemCategory] = [:] // generated in delegate

// MARK: Tab
enum TabType: Int, CaseIterable {
  case list = 0
  case profile
  case settings
  
  var tabItem: TabItemData {
    switch self {
    case .list:
      return TabItemData(image: "list-check", title: "TAB_LISTS")
    case .profile:
      return TabItemData(image: "user-large", title: "TAB_PROFILE")
    case .settings:
      return TabItemData(image: "gears", title: "TAB_SETTINGS")
    }
  }
}

// MARK: - Defaults
let DEF_LOGIN_EMAIL = "defUserEmail"

// MARK: - Database
let COL_USERS = "Users"
let COL_LISTS = "Lists"
let COL_LIST_LITEMS = "Items"

// MARK: - Notification
let NOTI_MIN_TIME_BETWEEN_NOTI: Double = 30 * -60
