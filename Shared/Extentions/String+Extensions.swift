//
//  String+Extensions.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import Foundation
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
