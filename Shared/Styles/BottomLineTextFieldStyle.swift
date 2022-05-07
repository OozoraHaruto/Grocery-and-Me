//
//  BottomLineTextFieldStyle.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import SwiftUI

struct BottomLineTextFieldStyle: TextFieldStyle {
  @FocusState var focused: Bool
  
  func _body(configuration: TextField<Self._Label>) -> some View {
    VStack() {
      configuration
        .focused($focused)
        .padding(.horizontal, PADDING_TEXTFIELD)
        .padding(.top, PADDING_TEXTFIELD)
    
      Rectangle()
        .frame(height: getRectHeight(focused), alignment: .bottom)
        .foregroundColor(getRectColor(focused))
        .padding(.bottom, getRectPadding(focused))
    }
  }
  
  private func getRectHeight(_ focused: Bool) -> CGFloat {
    return focused ? 2 : 1
  }
  
  private func getRectColor(_ focused: Bool) -> Color {
    return focused ? Color.bootBlue : Color.bootBorder
  }
  
  private func getRectPadding(_ focused: Bool) -> CGFloat {
    return focused ? 0 : 1
  }
}
