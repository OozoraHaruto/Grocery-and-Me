//
//  ListInfoView.swift
//  Grocery and Me
//
//  Created by 春音 on 1/5/22.
//

import SwiftUI
import FirebaseFirestore

struct ListInfoView: View {
  @Binding var presented: Bool
  @ObservedObject var listsObserver: ListsObv
  @State var viewingItem: GroceryList
  
  var body: some View {
    NavigationView {
      VStack (alignment: .center, spacing: PADDING_STACK) {
        if viewingItem.icon != "" {
          AsyncImage(url: URL(string: viewingItem.icon)) { phase in
            if let image = phase.image {
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: ICON_HEIGHT_LIST_INFO, height: ICON_HEIGHT_LIST_INFO)
                .cornerRadius(BORDER_RADIUS_ICON_LIST_INFO)
            } else if phase.error != nil {
              FontAwesomeSVG(svgName: "binary-slash",
                             frameHeight: ICON_HEIGHT_LIST_INFO,
                             color: Color.red.getCGColor(),
                             actAsSolid: false)
            } else {
              ProgressView()
            }
          }
          .frame(width: ICON_HEIGHT_LIST_INFO, height: ICON_HEIGHT_LIST_INFO)
          .padding()
        } else {
          AsyncImage(url: URL(string: viewingItem.creatorObj!.profileImageLink)) { phase in
            if let image = phase.image {
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: ICON_HEIGHT_LIST_INFO, height: ICON_HEIGHT_LIST_INFO)
                .cornerRadius(BORDER_RADIUS_ICON_PROFILE)
            } else if phase.error != nil {
              FontAwesomeSVG(svgName: "binary-slash",
                             frameHeight: ICON_HEIGHT_LIST_INFO,
                             color: Color.red.getCGColor(),
                             actAsSolid: false)
            } else {
              ProgressView()
            }
          }
          .frame(width: ICON_HEIGHT_LIST_INFO, height: ICON_HEIGHT_LIST_INFO)
          .padding()
        }
        
        Text(viewingItem.name)
          .font(.largeTitle)
        if let creator = viewingItem.creatorObj {
          Text("CREATED_BY \(creator.name)")
            .font(.body)
        }
        
        if viewingItem.sharedToUsers.count == 1 {
          Text("LIST_SHARED_WITH_YOU_ONLY")
        } else if viewingItem.sharedToUsers.count > 1 {
          Text("LIST_SHARED_WITH_YOU_AND \(viewingItem.sharedToUsers.count - 1)")
        }
        
        if viewingItem.sharedWithCurrentUser! {
          Button{
            listsObserver.leaveList(viewingItem.id!, sharedUsers: viewingItem.sharedToUsers) { _ in
              presented = false
            }
          } label: {
            Text("LIST_LEAVE")
          }.foregroundColor(.red)
        } else {
          NavigationLink("UI_EDIT") {
            ListForm(presented: $presented,
                     listsObserver: listsObserver,
                     editingItem: viewingItem)
          }
        }
        
        Spacer()
      }
#if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
#endif
      .toolbar() {
        Button {
          presented = false
        } label: {
          Text("UI_DONE").fontWeight(.heavy)
        }.foregroundColor(.blue)
      }
    }
  }
}

#Preview {
  ListInfoView(presented: .constant(true),
               listsObserver: ListsObv(haveData: true),
               viewingItem: GroceryList(name: "こうせいが好き",
                                        icon: "https://pbs.twimg.com/profile_images/1499869763140341762/Z1lMYx6m_400x400.jpg",
                                        color: "#15A0B8",
                                        creator: Firestore.firestore().document("Users/usr1"),
                                        sharedToUsers: []))
}
