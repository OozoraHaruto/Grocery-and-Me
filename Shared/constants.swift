//
//  constants.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import Foundation
import SwiftUI
import SwiftMessages

// MARK: - SwiftMessages
let boldTextAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
func getSwiftMessageAlertPopConfig() -> SwiftMessages.Config{
  var config = SwiftMessages.Config()

  config.presentationStyle = .center
  config.presentationContext = .window(windowLevel: .alert)
  config.duration = .forever
  config.dimMode = .gray(interactive: true)

  return config
}

func getSwiftMessageStatusLineConfig() -> SwiftMessages.Config{
  var config = SwiftMessages.Config()
  
  config.presentationStyle = .top
  config.presentationContext = .window(windowLevel: .statusBar)
  config.duration = .seconds(seconds: 5)
//  config.dimMode = .gray(interactive: true)
  
  return config
}

func getSwiftMessageBasicView(
  layout: MessageView.Layout = .cardView,
  theme: Theme = .warning,
  radius: CGFloat = 10
) -> MessageView {
  let view = MessageView.viewFromNib(layout: layout)
  
  view.configureTheme(theme)
  view.configureDropShadow()
  view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  (view.backgroundView as? CornerRoundingView)?.cornerRadius = radius
  view.button?.isHidden = true
  
  return view
}

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

// MARK: List
func getListFormColor(selectColor: String, typedColor: String) -> String {
  if selectColor.starts(with: "#") {
    return selectColor
  } else if selectColor == "FORM_LIST_COLOR_CUSTOM".localized {
    if typedColor.starts(with: "#") {
      return typedColor
    }
  }
  return "Default"
}

func getListColor(color: String) -> Color {
  if color.starts(with: "#") {
    return Color(hex: color)
  } else {
    return Color(uiColor: .label)
  }
}

// MARK: - Defaults
let DEF_LOGIN_EMAIL = "defUserEmail"

// MARK: - Database
let COL_USERS = "Users"
let COL_LISTS = "Lists"


func generatePicLink(_ emailHash: String, size: Int = 200) -> String {
  return String(format: "https://www.gravatar.com/avatar/%@?s=%d?f=retro", emailHash, size);
}
