//
//  View+Extensions.swift
//  Edited List Notification
//
//  Created by 春音 on 4/5/22.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
