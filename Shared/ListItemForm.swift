//
//  ListItemForm.swift
//  Grocery and Me
//
//  Created by 春音 on 3/5/22.
//

import SwiftUI

struct ListItemForm: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var itemsObserver: ListItemsObv
  @State var editingItem: ListItem?
  @State var name: String = ""
  @State var amount: String = ""
  @State var amountType: String = ""
  @State var picture: String = ""
  @State var category: String = ""
  @State var note: String = ""
  var themeColor: Color = .bootBlue
  
  @State var loading = false
  
  var body: some View {
    ZStack {
      List {
        TextField("FORM_LIST_ITEM_NAME", text: $name)
        
        TextField("FORM_LIST_ITEM_AMOUNT", text: $amount)
          .keyboardType(.numberPad)
        
        TextField("FORM_LIST_ITEM_AMOUNT_TYPE", text: $amountType)
        
        TextField("FORM_LIST_ITEM_PICTURE", text: $picture)
        
        Picker("FORM_LIST_ITEM_CATEGORY_SELECT", selection: $category){
          ForEach(CATEGORIES, id: \.self) { category in
            HStack(alignment: .center, spacing: PADDING_STACK){
              FontAwesomeSVG(svgName: category.icon,
                             frameHeight: ICON_HEIGHT_ITEM_LIST_HEADER,
                             color: themeColor.getCGColor(),
                             actAsSolid: false)
                .frame(width: ICON_HEIGHT_ITEM_LIST_HEADER, height: ICON_HEIGHT_ITEM_LIST_HEADER)
              Text(category.name)
            }.tag(category.key)
          }
        }
        
        Section("FORM_LIST_ITEM_NOTE") {
          TextEditor(text: $note)
        }
        
        Section() {
          Button{
            performAction()
          } label: {
            Text((editingItem!.id! == "") ? "FORM_LIST_ITEM_ADD" : "UI_SAVE")
          }
          
          if editingItem!.id! != "" {
            Button{
              loading = true
              itemsObserver.deleteItem(editingItem!.id!) { successful in
                if successful {
                  loading = false
                  self.presentationMode.wrappedValue.dismiss()
                }
              }
            } label: {
              Text("UI_DELETE")
                .foregroundColor(.red)
            }
          }
        }
        
        Section() {
          Button{
            self.presentationMode.wrappedValue.dismiss()
          } label: {
            Text("FORM_CANCEL")
              .foregroundColor(.red)
          }
        }
      }.listStyle(.grouped)
        .navigationViewStyle(DefaultNavigationViewStyle())
      
      if loading {
        ProgressFullPageView()
      }
    }
  }
  
  private func performAction() {
    loading = true
    if editingItem!.id == "" {
      itemsObserver.addItem(name: name,
                            amount: amount,
                            amountType: amountType,
                            picture: picture,
                            category: category,
                            note: note) { success in
        loading = false
        if success {
          self.presentationMode.wrappedValue.dismiss()
        }
      }
    } else {
      itemsObserver.editItem(itemData: editingItem!,
                             name: name,
                             amount: amount,
                             amountType: amountType,
                             picture: picture,
                             category: category,
                             note: note) { success in
        loading = false
        if success {
          self.presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

struct ListItemForm_Previews: PreviewProvider {
  static var previews: some View {
    ListItemForm(itemsObserver: ListItemsObv(),
                 editingItem: ListItem(name: "",
                                       amount: 1,
                                       amountType: "",
                                       picture: "",
                                       category: "",
                                       note: "",
                                       shown: false))
      .environment(\.locale, .init(identifier: "ja"))
  }
}
