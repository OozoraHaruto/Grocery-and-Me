//
//  TabItemView.swift
//  Grocery and Me
//
//  Created by 春音 on 17/4/22.
//  Referenced https://truongvankien.medium.com/custom-tabview-in-swiftui-e7c0bf5667ab
//

import SwiftUI

struct TabItemView: View {
  let data: TabItemData
  let isSelected: Bool
  
  var body: some View {
    VStack {
      if (isSelected) { // Using ternary operator doesn't work
        FontAwesomeSVG(svgName: data.image,
                       frameHeight: ICON_HEIGHT_HOME_TAB,
                       color: Color.blueDuo.getCGColor())
          .frame(width: ICON_HEIGHT_HOME_TAB, height: ICON_HEIGHT_HOME_TAB, alignment: .center)
      } else {
        FontAwesomeSVG(svgName: data.image,
                       frameHeight: ICON_HEIGHT_HOME_TAB,
                       color: Color.bootGray.getCGColor())
          .frame(width: ICON_HEIGHT_HOME_TAB, height: ICON_HEIGHT_HOME_TAB, alignment: .center)
      }
      
      Spacer().frame(height: 4)
      
      Text(data.title.localized)
        .foregroundColor(isSelected ? .black : .gray)
        .font(.caption)
    }.padding()
  }
}


struct TabItemView_Previews: PreviewProvider {
  static var previews: some View {
    TabItemView(data: TabItemData(image: "user-large", title: "TAB_LISTS"), isSelected: true)
    TabItemView(data: TabItemData(image: "user-large", title: "TAB_LISTS"), isSelected: false)
  }
}
