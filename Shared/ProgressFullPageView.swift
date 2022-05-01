//
//  ProgressFullPageView.swift
//  Grocery and Me
//
//  Created by 春音 on 23/4/22.
//

import SwiftUI

struct ProgressFullPageView: View {
  var title = "LOADING_WITH_DOTS"
  
  var body: some View {
    ZStack{
      Color.bootGray
        .opacity(0.4)
        .edgesIgnoringSafeArea(.all)
      
      ProgressView(title.localized)
        .progressViewStyle(CircularProgressViewStyle())
        .padding(50)
        .background(Color.bgGrayLight)
        .cornerRadius(25)
        .shadow(color: .gray, radius: 50)
    }
  }
}

struct ProgressFullPageView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressFullPageView()
    }
}
