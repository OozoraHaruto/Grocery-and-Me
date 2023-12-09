//
//  Color+Extensions(No noti).swift
//  Grocery and Me
//
//  Created by 春音 on 21/10/23.
//

import SwiftUI

extension Color {
  static var systemBackground: Color {
#if canImport(UIKit)
    return Color(.systemBackground)
#elseif canImport(AppKit)
    return Color(.windowBackgroundColor)
#else
    return Color.white
#endif
  }

  static var label: Color {
#if canImport(UIKit)
    return Color(.label)
#elseif canImport(AppKit)
    return Color(.labelColor)
#else
    return Color.black
#endif
  }

  static var listBackground: Color {
#if canImport(UIKit)
    return Color(.systemGroupedBackground)
#elseif canImport(AppKit)
    return Color(.windowBackgroundColor)
#else
    return Color.white
#endif
  }
}
