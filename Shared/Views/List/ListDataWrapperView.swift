//
//  ListDataWrapperView.swift
//  Grocery and Me
//
//  Created by 春音 on 1/5/22.
//

import SwiftUI
import FirebaseFirestore
#if canImport(ImageViewerRemote)
import ImageViewerRemote
#endif
import Introspect

struct ListDataWrapperView: View {
  @StateObject var itemsObserver: ListItemsObv = ListItemsObv()
  let listInfo: GroceryList?
  var themeColor: Color = .bootBlue
  @FocusState var editing: Bool
  @State var itemName = ""
  
  // For search results
  @State var searchResult: [ListItem] = []
  
  // for pushing edit form
  @State var editingItem: ListItem?
  @State var pushedView: Bool = false
  
  // for overlay image view
  @State var imageViewerLink: String = ""
  @State var showImageViewer: Bool = false

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      HStack(alignment: .center, spacing: PADDING_STACK) {
        Spacer(minLength: PADDING_STACK)
        TextField("ADD_ITEM", text: $itemName).onChange(of: itemName) { _ in
          itemsObserver.searchInItems(itemName) {
            searchResult = $0
          }
        }
          .focused($editing, equals: true)
          .font(.body)
          .textFieldStyle(.roundedBorder)
          .submitLabel(.return)
          .onSubmit() { addItem() }
          .textFieldStyle(.plain)

        if editing {
          Button {
            editing = false
          } label: {
            Text("UI_DONE")
          }
          .font(.body)
          .foregroundColor(themeColor)
        }
        
        Spacer(minLength: PADDING_STACK)
      }
#if os(iOS)
      .padding(.bottom, PADDING_STACK)
#else
      .padding(PADDING_STACK)
#endif
      Divider()
      
      if itemsObserver.items == nil ||
          itemsObserver.categorisedData == nil {
        VStack {
          Spacer()
          Text("LOADING_WITH_DOTS")
          Spacer()
        }
      } else if itemsObserver.items!.count == 0 {
        VStack {
          Spacer()
          Text("NO_ITEMS")
          Spacer()
        }
      } else {
        List {
          if itemName != "" && editing {
            HStack{
              Text("ADD_NEW_ITEM \(itemName)")
              Spacer()
              Button{
                editingItem = ListItem(name: itemName, amount: 1, amountType: "", picture: "", category: "CATEGORY_OTHER", note: "", shown: true)
              } label: {
                Image(systemName: "info.circle")
                  .foregroundColor(themeColor)
              }.buttonStyle(.plain)
            }.contentShape(Rectangle())
              .onTapGesture() { addItem() }
              .listRowSeparatorTint(themeColor)
            ForEach(searchResult, id: \.self) { item in
              ListDataItemCellView(item: item,
                                   editing: true,
                                   themeColor: themeColor,
                                   imageClicked: { imageLink in
                imageViewerLink = imageLink
                showImageViewer = !showImageViewer
              }){
                editingItem = $0
              }
                .onTapGesture(){
                  itemsObserver.setItemShown(item.id!, shown: true) { _ in
                    itemName = ""
                  }
                }
            }.listRowSeparatorTint(themeColor)
          } else {
            ForEach(itemsObserver.categorisedData!, id: \.id) { groupData in
              Section(content: {
                ForEach(groupData.items, id: \.self) { item in
                  ListDataItemCellView(item: item,
                                       editing: editing,
                                       themeColor: themeColor,
                                       imageClicked: { imageLink in
                    imageViewerLink = imageLink
                    showImageViewer = !showImageViewer
                  }) {
                    editingItem = $0
                  }.onTapGesture(){
                    if editing {
                      editingItem = item
                    } else {
                      itemsObserver.setItemShown(item.id!, shown: false) { _ in }
                    }
                  }
                }
              }, header: {
                HStack(alignment: .center, spacing: PADDING_STACK) {
                  FontAwesomeSVG(svgName: groupData.category.icon,
                                 frameHeight: ICON_HEIGHT_ITEM_LIST_HEADER,
                                 color: themeColor.getCGColor(),
                                 actAsSolid: false)
                  .frame(width: ICON_HEIGHT_ITEM_LIST_HEADER,
                         height: ICON_HEIGHT_ITEM_LIST_HEADER,
                         alignment: .center)
                  
                  Text(groupData.category.name)
                    .font(.body)
                    .foregroundColor(themeColor)
                }
              }).listSectionSeparatorTint(themeColor)
                .listRowSeparatorTint(themeColor)
            }
          }
        }.listStyle(.plain)
        
        NavigationLink(destination: ListItemForm(itemsObserver: itemsObserver,
                                                 editingItem: editingItem,
                                                 name: editingItem?.name ?? "",
                                                 amount: String(format: "%d", editingItem?.amount ?? 1),
                                                 amountType: editingItem?.amountType ?? "",
                                                 picture: editingItem?.picture ?? "",
                                                 category: editingItem?.category ?? "",
                                                 note: editingItem?.note ?? "",
                                                 themeColor: themeColor)) {
          EmptyView()
        }.hidden()
      }
    }.onAppear() {
      if let listInfo = listInfo {
        itemsObserver.listen(listInfo)
      }
    }.onChange(of: editingItem) {
      pushedView = ($0 != nil)
    }.onChange(of: pushedView){
      if (!$0) {
        editingItem = nil
        itemName = ""
        // Call after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          editing = true
        }
      }
    }
    .navigationTitle(listInfo?.name ?? "")
#if os(iOS)
    .navigationBarTitleDisplayMode(.inline)
    .introspectNavigationController() {nav in
      nav.navigationBar.tintColor = UIColor(themeColor)
    }
#endif
#if canImport(ImageViewerRemote)
    .overlay(ImageViewerRemote(imageURL: $imageViewerLink, viewerShown: $showImageViewer))
#endif
  }
  
  private func addItem() {
    itemsObserver.addItem(name: itemName) { success in
      if success {
        itemName = ""
      }
    }
  }
  
}

struct ListDataItemCellView: View {
  let item: ListItem
  let editing: Bool
  let themeColor: Color
  let imageClicked: (String) -> Void
  let editItem: (ListItem) -> Void
  
  var body: some View {
    HStack {
      if (item.picture != "") {
        Button {
          imageClicked(item.picture)
        } label: {
          AsyncImage(url: URL(string: item.picture)) { phase in
            if let image = phase.image {
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: ICON_HEIGHT_LIST_CELL, height: ICON_HEIGHT_LIST_CELL)
                .cornerRadius(5)
            } else if phase.error != nil {
              FontAwesomeSVG(svgName: "binary-slash",
                             frameHeight: ICON_HEIGHT_LIST_CELL,
                             color: Color.red.getCGColor(),
                             actAsSolid: false)
            }else {
              ProgressView()
            }
          }
          .frame(width: ICON_HEIGHT_LIST_CELL, height: ICON_HEIGHT_LIST_CELL)
        }.buttonStyle(.plain)
      }
      VStack (alignment: .leading) {
        HStack(alignment: .center, spacing: PADDING_STACK) {
          Text(item.name)
            .font(.body)
          
          Text("(\(item.getAmountLabel()))")
            .font(.caption)
            .foregroundColor(Color.secondary)
        }
        
        if item.note != "" {
          Text(item.note)
            .font(.caption)
            .lineLimit(1)
        }
      }
      
      Spacer()
      
      if editing {
        Button{
          editItem(item)
        } label: {
          Image(systemName: "info.circle")
            .foregroundColor(themeColor)
        }.buttonStyle(.plain)
      }
    }.contentShape(Rectangle())
  }
}

struct ListDataWrapperView_Previews: PreviewProvider {
  static let listInfo = GroceryList(name: "こうせいが好き",
                             icon: "https://pbs.twimg.com/profile_images/1499869763140341762/Z1lMYx6m_400x400.jpg",
                             color: "#15A0B8",
                             creator: Firestore.firestore().document("Users/usr1"),
                             sharedToUsers: [])
  
  static var previews: some View {
    ListDataWrapperView(itemsObserver: ListItemsObv(haveData: true),
                        listInfo: listInfo)
      .environment(\.locale, .init(identifier: "ja"))
    
    ListDataWrapperView(itemsObserver: ListItemsObv(haveData: false),
                        listInfo: listInfo)
      .environment(\.locale, .init(identifier: "ja"))
    
    ListDataWrapperView(itemsObserver: ListItemsObv(),
                        listInfo: listInfo)
      .environment(\.locale, .init(identifier: "ja"))
  }
}
