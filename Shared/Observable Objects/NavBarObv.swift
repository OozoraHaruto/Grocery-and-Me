//
//  NavBarObv.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import Foundation

class NavBarObv: ObservableObject {
  @Published var showNavBar: Bool = true
  
  public func setNavBar(_ show: Bool){
    self.showNavBar = show
  }
}
