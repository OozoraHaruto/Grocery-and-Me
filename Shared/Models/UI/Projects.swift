//
//  Projects.swift
//  Grocery and Me
//
//  Created by 春音 on 8/5/22.
//

import Foundation

struct Project: Identifiable {
  let id = UUID()
  let usage: String
  let author: String
  let link: String
}
