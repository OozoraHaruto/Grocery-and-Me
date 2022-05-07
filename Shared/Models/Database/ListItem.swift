//
//  ListItem.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

/**
  Structure of Grocery list Item
 
  - important: most value that is optional are generated later and added
  later in (mostly in `ListItemsObv`)
 
  **Variables**
 
  `id` The ID of the item inGrocery List
 
  `name` The name of the item in Grocery List
 
  `amount` The amount of item in the Grocery List
 
  `amountType` The type of amount
 
  `picture` The picture of the item in the Grocery List (url)
 
  `category` The category the item belongs to (found in `CATEGORIES` obj)
 
  `note` Any notes that is one needs to add
 
  `shown` The item is shown in the item list
 */
public struct ListItem: Codable, Hashable {
  var id: String? = ""
  let name: String
  let amount: Int
  let amountType: String
  let picture: String
  let category: String
  let note: String
  let shown: Bool
  
  /**
    Use to remove data that we only use for FE
   
    - returns:
      A dictionary of data that do not contain data we do not need
   */
  func getCleanDictionary() -> [String: Any] {
    return [
      "name" : name,
      "amount": amount,
      "amountType": amountType,
      "picture": picture,
      "category": category,
      "note": note,
      "shown": shown,
    ]
  }
  
  /**
    Use to get the label for item list w/o the brackets
   
    - returns: `amount` with `amountType` if there is
   */
  func getAmountLabel() -> String {
    if amountType == "" {
      return "\(amount)"
    } else {
      return "\(amount) \(amountType)"
    }
  }
}
