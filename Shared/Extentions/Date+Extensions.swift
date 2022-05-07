//
//  Date+Extensions.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import Foundation

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
