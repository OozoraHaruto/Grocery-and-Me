//
//  Collection+Extensions.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import Foundation

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
