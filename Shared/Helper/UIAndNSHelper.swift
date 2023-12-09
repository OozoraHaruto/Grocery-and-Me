//
//  UIAndNSHelper.swift
//  Grocery and Me
//
//  Created by はると on 10/12/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

func pasteboardString(_ data: String) {
#if os(iOS)
  UIPasteboard.general.string = data
#elseif os(macOS)
  let pasteboard = NSPasteboard.general
  pasteboard.declareTypes([.string], owner: nil)
  pasteboard.setString(data, forType: .string)
#endif
}

// pragma mark - Data

enum DeviceType {
  case pad
  case phone
  case mac
  case tv
  case watch
  case dunno
}

func getDeviceType() -> DeviceType {
#if os(iOS)
  if UIDevice.current.userInterfaceIdiom == .pad {
    return .pad
  } else if UIDevice.current.userInterfaceIdiom == .phone {
    return .phone
  } else if UIDevice.current.userInterfaceIdiom == .tv {
    return .tv
  } else {
    return .dunno
  }
#elseif os(macOS)
  return .mac
#elseif os(watchOS)
  return .watch
#endif
}

func openURL(_ url: URL) {
#if os(iOS)
  UIApplication.shared.open(url)
#elseif os(macOS)
  NSWorkspace.shared.open(url)
#endif
}
