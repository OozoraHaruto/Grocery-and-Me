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
  @Binding var selectedIndex: Int
  
  var body: some View {
    GeometryReader{ geometry in
      VStack {
        Spacer()
        
        HStack {
          Spacer()
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
          .frame(width: geometry.size.width - PADDING_CUSTOM_TAB_BAR,
                 height: HEIGHT_CUSTOM_TAB_BAR,
                 alignment: .bottom)
          .background(Color.bgGrayLight)
          .cornerRadius(BORDER_RADIUS_CUSTOM_TAB_BAR)
          .shadow(radius: SHADOW_RADIUS_CUSTOM_TAB_BAR, x: 0, y: 4)
          Spacer()
        }
      }.padding(.bottom, PADDING_CUSTOM_TAB_BAR_BOTTOM)
    }
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
