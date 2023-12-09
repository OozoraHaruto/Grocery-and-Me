//
//  ListForm.swift
//  Grocery and Me
//
//  Created by 春音 on 24/4/22.
//

import SwiftUI
import FirebaseFirestore

struct ListForm: View {
  @Environment(\.presentationMode) var presentationMode
  @Binding var presented: Bool
  @ObservedObject var listsObserver: ListsObv
  @State var editingItem: GroceryList?
  @State var name: String = ""
  @State var icon: String = ""
  @State var color: String = ""
  @State var colorSelect: String = "FORM_LIST_COLOR_CUSTOM".localized
  @State var sharedToUsers: [String] = []
  @State var sharedToUsersEmail: String = ""
  
  @State var loading = false
  
  var colors = [
    "#0079FF", "#004EA2", "#15A0B8",
    "#1F8537", "#6610F0", "#FB7C13",
    "#E83C8A", "#6D42C1", "#DC3545",
    "#1FC896", "#FFC106",
    "FORM_LIST_COLOR_DEFAULT".localized,
    "FORM_LIST_COLOR_CUSTOM".localized,
  ]
  
  var body: some View {
    ZStack {
      List {
        TextField("FORM_LIST_NAME", text: $name)
        
        TextField("FORM_LIST_ICON", text: $icon)
        
        Section(){
          TextField("FORM_LIST_COLOR", text: $color)
          Picker("FORM_LIST_COLOR_SELECT", selection: $colorSelect){
            ForEach(colors, id: \.self) {
              Text($0)
                .foregroundColor(getListColor(color: $0))
            }
          }
        } footer: {
          Text("FORM_LIST_SELECTED_COLOR")
            .foregroundColor(getListColor(color: getListFormColor(selectColor: colorSelect, typedColor: color)))
        }
        
        Section() {
          HStack{
            TextField("FORM_LIST_SHARE_EMAIL", text: $sharedToUsersEmail)
#if os(iOS)
              .keyboardType(.emailAddress)
#endif
            Button{
              if sharedToUsersEmail != "" {
                sharedToUsers.append(sharedToUsersEmail)
                sharedToUsersEmail = ""
              }
            }label: {
              Text("FORM_LIST_ADD_USER")
            }
          }
          ForEach(0 ..< sharedToUsers.count, id: \.self) { i in
            HStack{
              Text(sharedToUsers[i])
              
              Spacer()
              
              Button{
                sharedToUsers.remove(at: i)
              }label: {
                Text("DELETE")
                  .foregroundColor(.red)
              }
            }
          }
        } header: {
          Text("FORM_LIST_SEC_TITLE_SHARE")
        } footer: {
          Text("FORM_LIST_SEC_FOOTER_SHARE")
        }
        
        Section() {
          Button{
            prepareList()
          } label: {
            Text((editingItem == nil) ? "FORM_LIST_ADD" : "FORM_LIST_EDIT")
          }
          
          if editingItem != nil {
            Button{
              loading = true
              listsObserver.deleteList(editingItem!.id!) { successful in
                if successful {
                  loading = false
                  presented = false
                }
              }
            } label: {
              Text("FORM_LIST_DELETE")
                .foregroundColor(.red)
            }
          }
        }
        
        Section() {
          Button{
            popView()
          } label: {
            Text("FORM_CANCEL")
              .foregroundColor(.red)
          }
        }
      }
#if os(iOS)
      .listStyle(.grouped)
#endif
      .navigationTitle((editingItem == nil) ? "FORM_LIST_TITLE_NEW" : "FORM_LIST_TITLE_EDIT \(editingItem!.name)")
      .navigationViewStyle(DefaultNavigationViewStyle())
      .onAppear() {
        if let editingItem = editingItem {
          loading = true
          listsObserver.getListOfUsers(editingItem.sharedToUsers) { sharedUsers in
            self.editingItem?.sharedToUsersObj = sharedUsers

            name = editingItem.name
            icon = editingItem.icon
            color = editingItem.color
            colorSelect = colors.last!

            for user in sharedUsers {
              sharedToUsers.append(user.email)
            }
            loading = false
          }
        }
      }
      
      if loading {
        ProgressFullPageView()
      }
    }
  }
  
  private func prepareList() {
    loading = true
    if editingItem == nil {
      listsObserver.addList(name: name,
                            icon: icon,
                            color: getListFormColor(selectColor: colorSelect, typedColor: color),
                            sharedUsers: sharedToUsers) { success in
        loading = false
        
        if (success) {
          presented = false
        }
      }
    } else {
      listsObserver.editList(listData: editingItem!,
                             name: name,
                             icon: icon,
                             color: getListFormColor(selectColor: colorSelect, typedColor: color),
                             sharedUsers: sharedToUsers) { success in
        loading = false
        
        if (success) {
          presented = false
        }
      }
    }
  }
  
  private func popView() {
    if editingItem == nil {
      presented = false
    } else {
      self.presentationMode.wrappedValue.dismiss()
    }
  }
}

struct ListForm_Previews: PreviewProvider {
  static var previews: some View {
    ListForm(presented: .constant(false),
             listsObserver: ListsObv(haveData: true),
             editingItem: GroceryList(name: "こうせいが好き",
                                      icon: "https://pbs.twimg.com/profile_images/1499869763140341762/Z1lMYx6m_400x400.jpg",
                                      color: "#15A0B8",
                                      creator: Firestore.firestore().document("Users/usr1"),
                                      sharedToUsers: []))
      .environment(\.locale, .init(identifier: "ja"))
    ListForm(presented: .constant(false), listsObserver: ListsObv(haveData: true))
      .environment(\.locale, .init(identifier: "ja"))
  }
}
