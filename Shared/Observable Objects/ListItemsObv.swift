//
//  ListItemsObv.swift
//  Grocery and Me
//
//  Created by 春音 on 2/5/22.
//

import Foundation
import FirebaseFirestore


class ListItemsObv: ObservableObject {
  let db = Firestore.firestore()
  var collectionListItems: CollectionReference? = nil
  @Published var items: [ListItem]? = nil
  @Published var categorisedData: [ItemGroup]? = nil
  var itemListener: ListenerRegistration? = nil
  
  init(_ id: String = "") {
    stopListen()
  }
  
  /**
    Method to used to create test data for UI
   
    - parameters:
      - haveData: mock mock data
   
    - returns: Nothing
   */
  init(haveData: Bool){ //https://pbs.twimg.com/profile_images/1499869763140341762/Z1lMYx6m_400x400.jpg
    if haveData {
      
      items = [
        ListItem(name: "弟のパンツ",
                 amount: 1,
                 amountType: "",
                 picture: "https://m.media-amazon.com/images/I/81zYVCsw2jS._AC_UL1250_.jpg",
                 category: "CATEGORY_CLOTHES",
                 note: "履いたら可愛いなぁ",
                 shown: true),
        ListItem(name: "チーズ",
                 amount: 1,
                 amountType: "",
                 picture: "",
                 category: "CATEGORY_DAIRY",
                 note: "",
                 shown: true),
        ListItem(name: "弟のパジャマ",
                 amount: 1,
                 amountType: "",
                 picture: "https://m.media-amazon.com/images/I/81eTkRNcNXL._AC_UL1500_.jpg",
                 category: "CATEGORY_CLOTHES",
                 note: "可愛いんだ",
                 shown: true),
      ]
      
      categorisedData = categoriseItem(items!)
    } else {
      items = []
      categorisedData = []
    }
  }
  
  deinit {
    stopListen()
  }
  
  
  /**
    Method to used to initiate listener
   
    - parameters:
      - uid: the logged in user's userid
   
    - returns: Nothing
   */
  func listen(_ id: String) {
    stopListen()
    if (id == "") { return }
    collectionListItems = Firestore.firestore().collection(COL_LISTS).document(id).collection(COL_LIST_LITEMS)
    
    if itemListener == nil {
      itemListener = collectionListItems!
        .addSnapshotListener {(querySnapshot, error) in
          
        self.parseListData(querySnapshot, error) { items in
          self.categorisedData = self.categoriseItem(items)
          self.items = items
        }
      }
    }
  }
  
  /**
    Parse the list data into GroceryList ojects
   
    - parameters:
      - querySnapshot: snapshot of the reply
      - error: the error of the reply
      - completion: the callback will return a list of `GroceryList` object
   
    - returns: Nothing
   */
  private func parseListData(_ querySnapshot: QuerySnapshot?,
                             _ error: Error?,
                             completion: @escaping ([ListItem]) -> Void) {
    guard let snapshot = querySnapshot else {
      print("Error fetching snapshots: \(error!)")
      return completion([])
    }
    
    var tempList: [ListItem] = []
    tempList.reserveCapacity(snapshot.documents.count)
    
    for (_, document) in snapshot.documents.enumerated() {
      do {
        var item = try document.data(as: ListItem.self)
        item.id = document.documentID
        tempList.append(item)
      } catch (let error) {
        print("Error decoding List Object: \(error)")
      }
    }
    tempList = tempList.sorted(by: { $0.name < $1.name })
    
    completion(tempList)
  }
  
  /**
    Stop listing to server and reset all data
   */
  func stopListen() {
    itemListener?.remove()
    itemListener = nil
    categorisedData = nil
  }
  
  func categoriseItem(_ items: [ListItem]) -> [ItemGroup] {
    if (items.count == 0) { return [] }
        
    var categorise: [String: [ListItem]] = [:]
    for item in items {
      if !item.shown { continue }
      if var categoryItems = categorise[item.category] {
        categoryItems.append(item)
        categorise[item.category] = categoryItems
      } else {
        categorise[item.category] = [item]
      }
    }
    
    var grouped: [ItemGroup] = []
    grouped.reserveCapacity(categorise.count)
    for (k, categorised) in categorise {
      if let cat = CATEGORIES_DICT[k] {
        grouped.append(ItemGroup(category: cat, items: categorised))
      }
    }
    grouped = grouped.sorted(by: {$0.category.name < $1.category.name})
    return grouped
  }
  
  /**
    Add a list Item in the database
   
    - parameters:
      - name: the name of the item
      - amount: the number / weight of the data
      - amountType: the type of the amount
      - picture: the link of the picture of the item
      - category: the category that item belongs to
      - note: anything the user wants to include the data
      - completion: will return if the list item has been successfully added
   
    - returns: Nothing
   */
  func addItem(name: String,
               amount: String = "1",
               amountType: String = "",
               picture: String = "",
               category: String = "CATEGORY_OTHER",
               note: String = "",
               completion:@escaping (Bool) -> Void) {
    let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
    if name == "" { return completion(true) }
    
    let item = ListItem(name: name,
                        amount: Int(amount) ?? 1,
                        amountType: amountType.trimmingCharacters(in: .whitespacesAndNewlines),
                        picture: picture,
                        category: category,
                        note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                        shown: true)

    self.collectionListItems!.addDocument(data: item.getCleanDictionary()) { err in
      if let err = err {
        print("Error adding document: \(err)")
        completion(false)
      } else {
        completion(true)
      }
    }
  }
  
  /**
    Edit a list Item in the database
   
    - parameters:
      - itemData: the exiting data in the database
      - name: the name of the item
      - amount: the number / weight of the data
      - amountType: the type of the amount
      - picture: the link of the picture of the item
      - category: the category that item belongs to
      - note: anything the user wants to include the data
      - completion: will return if the list item has been successfully added
   
    - returns: Nothing
   */
  func editItem(itemData: ListItem,
                name: String,
                amount: String,
                amountType: String,
                picture: String,
                category: String,
                note: String,
                completion:@escaping (Bool) -> Void) {
    // Check diff
    var diff: [String:Any] = [:]
    if (name != itemData.name) { diff["name"] = name }
    let amt = Int(amount) ?? itemData.amount
    if (amt != itemData.amount) { diff["amount"] = amt }
    let amtType = amountType.trimmingCharacters(in: .whitespacesAndNewlines)
    if (amtType != itemData.amountType) { diff["amountType"] = amtType }
    if (picture != itemData.picture) { diff["picture"] = picture }
    if (category != itemData.category) { diff["category"] = category }
    let nte = note.trimmingCharacters(in: .whitespacesAndNewlines)
    if (nte != itemData.note) { diff["note"] = nte }

    if diff.count > 0 {
      self.collectionListItems!.document(itemData.id!).updateData(diff) { err in
        if let err = err {
          print("Error editing document: \(err)")
          completion(false)
        } else {
          completion(true)
        }
      }
    } else {
      print("No data changed")
      completion(true)
    }
  }
  
  /**
    Set if the item should be shown in the list view
   
    - parameters:
      - id: the id of the list item
      - shown: if the item should be shown
      - completion:will return if the list has been successfully edited
   
    - returns: Nothing
   */
  func setItemShown(_ id: String,
                    shown: Bool,
                    completion:@escaping (Bool) -> Void) {
    self.collectionListItems!.document(id).updateData(["shown": shown]) { err in
      if let err = err {
        print("Error editing document: \(err)")
        completion(false)
      } else {
        completion(true)
      }
    }
  }
  
  /**
    Search for keyword in items
   
    - parameters:
      - keyword: the keyword to look for
      - includeShownItems: to search for shown items as well
      - completion:will return an array of items found
   
    - returns: Nothing
   */
  func searchInItems(_ keyword: String,
                     includeShownItems: Bool = false,
                     completion: @escaping ([ListItem]) -> Void) {
    if items!.count == 0 || keyword == "" { return completion([])}
    
    DispatchQueue.global(qos: .background).async {
      let items = self.items!.filter() {
        $0.name.contains(keyword) && (!$0.shown || includeShownItems)
      }
      completion(items)
    }
  }
  
  /**
    Delete the item
   
    - parameters:
      - id: the ID of the list
      - completion: will return if the list item has been successfully deleted
   
    - returns: Nothing
   */
  func deleteItem(_ id: String, completion:@escaping (Bool) -> Void) {
    collectionListItems!.document(id).delete() {err in
      if let err = err {
        print("Error removing document: \(err)")
        completion(false)
      } else {
        print("Document successfully removed!")
        completion(true)
      }
    }
  }
}
