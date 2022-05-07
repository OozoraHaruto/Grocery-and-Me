//
//  SwiftMessages.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import SwiftUI
import SwiftMessages

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
