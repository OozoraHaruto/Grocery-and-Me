//
//  Color+Extensions.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import SwiftUI

extension Color {
  static var bgGrayLight: Color {
    return Color.init("bgGrayLight")
  }
  
  static var bootBlue: Color{
    return Color.init("colBlue")
  }
  
  static var blueDuo: Color{
    return Color.init("colBlueDuo")
  }
  
  static var bootCyan: Color{
    return Color.init("colCyan")
  }
  
  static var bootDark: Color{
    return Color.init("colDark")
  }
  
  static var bootGray: Color{
    return Color.init("colGray")
  }
  
  static var bootGreen: Color{
    return Color.init("colGreen")
  }
  
  static var GreenDuo: Color{
    return Color.init("colGreenDuo")
  }
  
  static var bootIndigo: Color{
    return Color.init("colIndigo")
  }
  
  static var bootLight: Color{
    return Color.init("colLight")
  }
  
  static var bootOrange: Color{
    return Color.init("colOrange")
  }
  
  static var bootPink: Color{
    return Color.init("colPink")
  }
  
  static var bootPurple: Color{
    return Color.init("colPurple")
  }
  
  static var bootRed: Color{
    return Color.init("colRed")
  }
  
  static var bootTeal: Color{
    return Color.init("colTeal")
  }
  
  static var WhiteDuo: Color{
    return Color.init("colWhiteDuo")
  }
  
  static var bootYellow: Color{
    return Color.init("colYellow")
  }
  
  static var bootBorder: Color{
    return Color.init("borderColor")
  }
  
  static var colTabIconSelected: Color{
    return Color.init("colTabIconSelected")
  }
  
  static var colTabIconUnSelected: Color{
    return Color.init("colTabIconUnSelected")
  }
  
  public init(hex: String) { // https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
    let r, g, b, a: CGFloat
    
    let start = hex.index(hex.startIndex, offsetBy: hex.hasPrefix("#") ? 1 : 0)
    var hexColor = String(hex[start...])
    if(hexColor.count == 6){
      hexColor += "FF"
    }
    
    if hexColor.count == 8 {
      let scanner = Scanner(string: hexColor)
      var hexNumber: UInt64 = 0
      
      if scanner.scanHexInt64(&hexNumber) {
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = hexColor.count == 8 ? CGFloat(hexNumber & 0x000000ff) / 255 : 1
        
        #if os(macOS)
        self.init(NSColor.init(red: r, green: g, blue: b, alpha: a))
        #else
        self.init(UIColor.init(red: r, green: g, blue: b, alpha: a))
        #endif
        return
      }
    }
    
    self.init(red: 1, green: 1, blue: 1)
    return
  }
  
  func getCGColor() -> CGColor {
    #if os(macOS)
    return NSColor(self).cgColor
    #else
    return UIColor(self).cgColor
    #endif
  }
}
