//
//  GroceryListHelper.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import SwiftUI

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
