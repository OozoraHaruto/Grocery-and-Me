//
//  extentions.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import Foundation
import SwiftUI
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

extension String {
  var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
  func localized(withComment:String) -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
  }
  func capitalizingFirstLetter() -> String {
    return prefix(1).uppercased() + self.lowercased().dropFirst()
  }
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
  func toDate(withFormat format: String) -> Date{
    let dateFormatter               = DateFormatter()
    dateFormatter.timeZone          = .current
    dateFormatter.locale            = .current
    dateFormatter.calendar          = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat        = format
    
    return dateFormatter.date(from: self)!
  }
  func toDate(usingTimezone timezone: TimeZone = .current) -> Date{
    let dateFormatter               = ISO8601DateFormatter()
    dateFormatter.timeZone          = timezone
//    print("Timezone", TimeZone.knownTimeZoneIdentifiers)

    return dateFormatter.date(from: self)!
  }
  func toLocalize(using value: Any) -> String {
    return String(format: NSLocalizedString(self, comment: ""), value as! CVarArg)
  }
  
  var MD5: String {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = self.data(using:.utf8)!
    var digestData = Data(count: length)

    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
      messageData.withUnsafeBytes { messageBytes -> UInt8 in
        if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
          let messageLength = CC_LONG(messageData.count)
          CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
        }
        return 0
      }
    }
    return digestData.map { String(format: "%02hhx", $0) }.joined()
  }
}

extension Date {
  func isBetween(_ date1: Date, and date2: Date) -> Bool {
    return (min(date1, date2) ... max(date1, date2)).contains(self)
  }
  func timeDifference(to: Date) -> String{
    let timeInterval                = to.timeIntervalSince(self)
    let formatter                   = DateComponentsFormatter()
    formatter.unitsStyle            = .abbreviated
    return formatter.string(from: timeInterval)!
  }
  func toString(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
    let dateFormatter               = DateFormatter()
    dateFormatter.timeZone          = .current
    dateFormatter.locale            = .current
    dateFormatter.calendar          = Calendar(identifier: .gregorian)
    dateFormatter.dateStyle         = dateStyle
    dateFormatter.timeStyle         = timeStyle
    
    return dateFormatter.string(from: self)
  }
  func toString(usingFormat format: String) -> String {
    let dateFormatter               = DateFormatter()
    dateFormatter.timeZone          = .current
    dateFormatter.locale            = .current
    dateFormatter.calendar          = Calendar(identifier: .gregorian)
    dateFormatter.dateFormat        = format
    
    return dateFormatter.string(from: self)
  }
}

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
        
        self.init(UIColor.init(red: r, green: g, blue: b, alpha: a))
        return
      }
    }
    
    self.init(red: 1, green: 1, blue: 1)
    return
  }
  
  func getCGColor() -> CGColor {
    return UIColor(self).cgColor
  }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

// https://stackoverflow.com/a/35601394
extension Collection where Element == Optional<Any> {
  func allNil() -> Bool {
    return allSatisfy { $0 == nil }
  }

  func anyNil() -> Bool {
    return first { $0 == nil } != nil
  }

  func allNotNil() -> Bool {
    return !allNil()
  }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
