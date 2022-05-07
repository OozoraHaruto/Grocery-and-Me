//
//  ListSelectionView.swift
//  Grocery and Me
//
//  Created by 春音 on 17/4/22.
//

import SwiftUI

struct ListSelectionView: View {
  @ObservedObject var auth: Authentication
  @ObservedObject var navBarObserver: NavBarObv
  
  @StateObject var listsObserver: ListsObv = ListsObv()
  @State var presentedCreateView = false
  @State var editingList: GroceryList?
  @State var presentEditingView = false
  
  @State var pushingItem: GroceryList?
  @State var pushedView = false
  
  var body: some View {
    NavigationView {
      VStack{
        if (listsObserver.createdLists == nil ||
            listsObserver.sharedLists == nil) {
          Text("LOADING")
            .font(.headline)
            .foregroundColor(.bootGray)
        } else if (listsObserver.createdLists!.count <= 0 &&
                   listsObserver.sharedLists!.count <= 0) {
          VStack(alignment: .center, spacing: PADDING_STACK) {
            Text("NO_LIST")
              .font(.headline)
              .foregroundColor(.bootGray)
            
            Button{
              presentedCreateView = !presentedCreateView
            } label: {
              Text("LIST_ADD")
            }
          }
        } else {
          List{
            Section(){
              ForEach(listsObserver.createdLists!, id: \.self) { item in
                ListCellView(listItem: item,
                             editingList: $editingList)
                  .onTapGesture() { pushingItem = item }
              }.onDelete(perform: delete)
            }
            
            Section(){
              ForEach(listsObserver.sharedLists!, id: \.self) { item in
                ListCellView(listItem: item,
                             editingList: $editingList)
                  .onTapGesture() { pushingItem = item }
              }.onDelete(perform: leaveList)
            }
          }
        }
        
        NavigationLink(destination: ListDataWrapperView(listInfo: pushingItem,
                                                        themeColor: pushingItem?.getColor() ?? .bootBlue),
                       isActive: $pushedView) {
          EmptyView()
        }
      }.sheet(isPresented: $presentedCreateView) {
        ListAdd(presented: $presentedCreateView,
                listsObserver: listsObserver)
      }.sheet(isPresented: $presentEditingView, onDismiss: {
        editingList = nil
      }){
        ListInfoView(presented: $presentEditingView,
                     listsObserver: listsObserver,
                     viewingItem: editingList!)
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle("LISTS")
      .toolbar() {
        ToolbarItem(placement: .navigationBarTrailing) {
          if ((listsObserver.createdLists ?? []).count > 0 ||
              (listsObserver.sharedLists ?? []).count > 0) {
            Button{
              presentedCreateView = !presentedCreateView
            } label: {
              Image(systemName: "plus")
            }.foregroundColor(.blue)
          } else {
            EmptyView()
          }
        }
      }
      .onChange(of: auth.uid) {newValue in
        listsObserver.listen(auth.uid)
      }.onChange(of: pushingItem) {newValue in
        pushedView = (newValue != nil)
        navBarObserver.setNavBar((newValue == nil))
      }.onChange(of: pushedView){
        if (!$0) {
          pushingItem = nil
        }
      }.onChange(of: editingList) {newValue in
        presentEditingView = (newValue != nil)
      }.onAppear(perform: {
        listsObserver.listen(auth.uid)
      })
    }
  }
  
  func delete(at offsets: IndexSet) {
    if let i = offsets.first {
      let item: GroceryList = listsObserver.createdLists![i]
      listsObserver.deleteList(item.id!) { _ in }
    }
  }
  
  func leaveList(at offsets: IndexSet) {
    if let i = offsets.first {
      let item: GroceryList = listsObserver.sharedLists![i]
      listsObserver.leaveList(item.id!, sharedUsers: item.sharedToUsers) { _ in }
    }
  }
}

struct ListCellView: View {
  var listItem: GroceryList
  var color: Color
  @Binding var editingList: GroceryList?
  
  init (listItem: GroceryList,
        editingList: Binding<GroceryList?>) {
    self.listItem = listItem
    self.color = getListColor(color: listItem.color)
    self._editingList = editingList
  }
  
  var body: some View {
    HStack{
      if (listItem.icon != "") {
        AsyncImage(url: URL(string: listItem.icon)) { phase in
          if let image = phase.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: ICON_HEIGHT_LIST_CELL, height: ICON_HEIGHT_LIST_CELL)
              .cornerRadius(5)
          } else if phase.error != nil {
            FontAwesomeSVG(svgName: "binary-slash",
                           frameHeight: ICON_HEIGHT_LIST_CELL,
                           color: UIColor.red.cgColor,
                           actAsSolid: false)
          }else {
            ProgressView()
          }
        }
        .frame(width: ICON_HEIGHT_LIST_CELL, height: ICON_HEIGHT_LIST_CELL)
      } else if listItem.sharedWithCurrentUser! && listItem.creatorObj != nil {
        AsyncImage(url: URL(string: listItem.creatorObj!.profileImageLink)) { phase in
          if let image = phase.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: ICON_HEIGHT_LIST_CELL, height: ICON_HEIGHT_LIST_CELL)
              .cornerRadius(5)
          } else if phase.error != nil {
            FontAwesomeSVG(svgName: "binary-slash",
                           frameHeight: ICON_HEIGHT_LIST_CELL,
                           color: UIColor.red.cgColor,
                           actAsSolid: false)
          }else {
            ProgressView()
          }
        }
        .frame(width: ICON_HEIGHT_LIST_CELL, height: ICON_HEIGHT_LIST_CELL)
      } else {
        FontAwesomeSVG(svgName: "list-check",
                       frameHeight: ICON_HEIGHT_LIST_CELL,
                       color: color.getCGColor(),
                       actAsSolid: true)
          .frame(width: ICON_HEIGHT_LIST_CELL, height: ICON_HEIGHT_LIST_CELL, alignment: .center)
      }
      VStack(alignment: .leading) {
        Text(listItem.name)
          .font(.body)
        if listItem.sharedWithCurrentUser! && listItem.creatorObj != nil {
          Text("CREATED_BY \(listItem.creatorObj!.name)")
              .font(.caption)
        }
      }
      Spacer()
      
      Button{
        editingList = listItem
      } label: {
        Image(systemName: "info.circle")
          .foregroundColor(Color(UIColor.systemBlue))
      }.buttonStyle(.plain)
    }.contentShape(Rectangle())
  }
}

struct ListSelectionView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ListSelectionView(auth: Authentication(loggedIn: false), navBarObserver: NavBarObv(), listsObserver: ListsObv(haveData: true))
        .environment(\.locale, .init(identifier: "ja"))
      ListSelectionView(auth: Authentication(loggedIn: false), navBarObserver: NavBarObv(), listsObserver: ListsObv(haveData: false))
        .environment(\.locale, .init(identifier: "ja"))
    }
  }
}
