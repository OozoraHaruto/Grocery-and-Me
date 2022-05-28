//
//  ListAdd.swift
//  Grocery and Me
//
//  Created by 春音 on 1/5/22.
//

import SwiftUI

struct ListAdd: View {
  @Binding var presented: Bool
  @ObservedObject var listsObserver: ListsObv
  var body: some View {
    NavigationView{
      ListForm(presented: $presented, listsObserver: listsObserver)
    }
  }
}

struct ListAdd_Previews: PreviewProvider {
  static var previews: some View {
    ListAdd(presented: .constant(false), listsObserver: ListsObv(haveData: true))
      .environment(\.locale, .init(identifier: "ja"))
  }
}
