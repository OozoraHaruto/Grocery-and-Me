//
//  SettingsView.swift
//  Grocery and Me
//
//  Created by 春音 on 17/4/22.
//

import SwiftUI

struct SettingsView: View {
  let icons = [
    Project(usage: "USAGE_APP_ICON",
            author: "いらすとや",
            link: "https://www.irasutoya.com/"),
    Project(usage: "USAGE_SVG_ICON",
            author: "fontawesome",
            link: "https://fontawesome.com/"),
  ]
  
  let packages = [
    Project(usage: "USAGE_IMAGE_LIGHTBOX",
            author: "Jake-Short",
            link: "https://github.com/Jake-Short/swiftui-image-viewer"),
    Project(usage: "USAGE_SVG_RENDERER",
            author: "PocketSVG",
            link: "https://github.com/pocketsvg/PocketSVG"),
    Project(usage: "USAGE_ALERTS",
            author: "SwiftKickMobile",
            link: "https://github.com/SwiftKickMobile/SwiftMessages"),
    Project(usage: "USAGE_INTROSPECT",
            author: "siteline",
            link: "https://github.com/siteline/SwiftUI-Introspect"),
    Project(usage: "USAGE_DATABASE_NOTI",
            author: "Firebase",
            link: "https://github.com/firebase/firebase-ios-sdk"),
  ]
  
  var body: some View {
    NavigationView{
      VStack (alignment: .leading, spacing: PADDING_STACK) {
        List {
          Section(header: Text("USAGE_HEADER_ICON")){
            ForEach(icons, id: \.id) {
              SettingsExternalProjectView(project: $0)
            }
          }
          
          Section(header: Text("USAGE_HEADER_PACKAGES")){
            ForEach(packages, id: \.id) {
              SettingsExternalProjectView(project: $0)
            }
          }
          
          Section(footer: Text("VERSION \((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)")){
            EmptyView()
          }
        }.listStyle(.grouped)
      }.navigationTitle("TAB_SETTINGS")
    }
  }
}

struct SettingsExternalProjectView: View {
  let project: Project
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(project.usage.localized)
          .font(.body)
        Text("PROJECT_AUTHOR \(project.author)")
          .font(.caption)
          .foregroundColor(.bootGray)
        Spacer()
      }
      
      Text(project.link)
        .font(.caption)
    }.contentShape(Rectangle())
      .onTapGesture(){
        if let url = URL(string: project.link) {
            UIApplication.shared.open(url)
        }
      }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .environment(\.locale, .init(identifier: "ja"))
  }
}
