//
//  TabBottomView.swift
//  Grocery and Me
//
//  Created by 春音 on 17/4/22.
//  Referenced https://truongvankien.medium.com/custom-tabview-in-swiftui-e7c0bf5667ab
//

import SwiftUI

struct TabBottomView: View {
  let tabbarItems: [TabItemData]
  let width: CGFloat = UIScreen.main.bounds.width - 32
  @Binding var selectedIndex: Int
  
  var body: some View {
    HStack {
      Spacer()
      
      ForEach(0 ..< tabbarItems.count, id:\.self) { index in
        let item = tabbarItems[index]
        Button {
          self.selectedIndex = index
        } label: {
          let isSelected = selectedIndex == index
          TabItemView(data: item, isSelected: isSelected)
        }
        Spacer()
      }
    }
    .frame(width: width)
    .background(Color.bgGrayLight)
    .cornerRadius(13)
    .shadow(radius: 5, x: 0, y: 4)
  }
}
struct TabBottomView_Previews: PreviewProvider {
  static var previews: some View {
    TabBottomView(tabbarItems: [
      TabItemData(image: "user-large", title: "TAB_LISTS"),
      TabItemData(image: "user-large", title: "TAB_LISTS")
    ], selectedIndex: .constant(0))
  }
}
