//
//  ItemGroup.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

import Foundation

public struct ItemGroup: Identifiable {
  public let id = UUID()
  let category: ItemCategory
  let items: [ListItem]
}
