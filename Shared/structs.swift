//
//  structs.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import Foundation
import SwiftUI
import PocketSVG
import FirebaseFirestore

// MARK: - Views
struct FontAwesomeSVG: UIViewRepresentable {
  let svgName: String
  let frameHeight: CGFloat
  var color: CGColor? = UIColor.white.cgColor
  var color2: CGColor? = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
  var swapColor: Bool? = false
  var actAsSolid: Bool? = false
  
  func makeUIView(context: Context) -> UIView {
    let scale = frameHeight / ICON_HEIGHT_DEFAULT
    let url = Bundle.main.url(forResource: self.svgName, withExtension: "svg")!
    let svgView = UIView()
    svgView.contentMode = .scaleAspectFit
    let paths = SVGBezierPath.pathsFromSVG(at: url)
    let svgLayer = CALayer()
    svgLayer.frame = svgView.bounds
    svgLayer.contentsGravity = .center
    for (index, path) in paths.enumerated() {
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = path.cgPath
      if(swapColor!){
        shapeLayer.fillColor = (index == 0) ? getColor2() : color
      }else{
        shapeLayer.fillColor = (index == 0) ? color : getColor2()
      }
      svgLayer.addSublayer(shapeLayer)
    }
    
    svgLayer.transform = CATransform3DMakeScale(scale, scale, 1.0)
    svgLayer.position = svgView.center
    svgView.layer.addSublayer(svgLayer)
    return svgView
  }
  
  func getColor2() -> CGColor {
    if (actAsSolid!) {
      return color!
    }
    if(color2!.components == UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor.components && color !=  UIColor.white.cgColor){
      return color!.copy(alpha: 0.5)!
    }
    return color2!
  }
  
  func updateUIView(_ uiView: UIView, context: Context){ }
}

struct BottomLineTextFieldStyle: TextFieldStyle {
  @FocusState var focused: Bool
  
  func _body(configuration: TextField<Self._Label>) -> some View {
    VStack() {
      configuration
        .focused($focused)
        .padding(.horizontal, PADDING_TEXTFIELD)
        .padding(.top, PADDING_TEXTFIELD)
    
      Rectangle()
        .frame(height: getRectHeight(focused), alignment: .bottom)
        .foregroundColor(getRectColor(focused))
        .padding(.bottom, getRectPadding(focused))
    }
  }
  
  private func getRectHeight(_ focused: Bool) -> CGFloat {
    return focused ? 2 : 1
  }
  
  private func getRectColor(_ focused: Bool) -> Color {
    return focused ? Color.bootBlue : Color.bootBorder
  }
  
  private func getRectPadding(_ focused: Bool) -> CGFloat {
    return focused ? 0 : 1
  }
}

// MARK: JSON
struct JSON {
    static let encoder = JSONEncoder()
}

// MARK: TabView
struct TabItemData {
  let image: String
  let title: String
}

// MARK: - Database
/**
  Structure of User
 
  - important: We use auth by firebase so auth will not be saved here.
  `email` and `profileImageLink` here are backups. Update both here and auth if changed.
 
  **Variables**
 
  `id` The ID of the user (`uid` in auth)
 
  `name` The name of the user (`displayName` in auth)
 
  `email` The email of the user (`email` in auth)
 
  `profileImage` The email hash of the user
 
  `profileImageLink` combination of hash and link from gravatar (`photoURL` in auth)
 */
public struct User: Codable, Hashable {
  let id: String
  let name: String
  let email: String
  let profileImage: String
  let profileImageLink: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case profileImage
    case profileImageLink
  }
  
  init(id: String, name: String, email:String){
    self.id = id
    self.name = name
    self.email = email
    let emailMD5 = email.lowercased().MD5
    self.profileImage = emailMD5
    self.profileImageLink = generatePicLink(emailMD5)
  }
  
  init(id: String, name: String, email:String, profileImage: String){
    self.id = id
    self.name = name
    self.email = email
    self.profileImage = profileImage
    self.profileImageLink = generatePicLink(profileImage)
  }
  
  func getDbBRef() -> DocumentReference {
    return Firestore.firestore().document(String(format: "%@/%@", COL_USERS, id))
  }
}

/**
  Structure of Grocery list
 
  - important: most value that is optional are generated later and added
  later in (mostly in `ListsObv`)
 
  **Variables**
 
  `id` The ID of the Grocery List
 
  `name` The name of the Grocery List
 
  `icon` The name of the Grocery List (url)
 
  `color` The color of the Grocery List (Hexadecimal)
 
  `creator` The creator of the Grocery List
 
  `creatorObj` The creator of the Grocery List (`User` obj)
 
  `sharedToUsers` The list of users the Grocery List is shared with
 
  `sharedToUsersObj` The list of users the Grocery List is shared with (`[User]` obj)
 
  `sharedWithCurrentUser` Check if the list is shared with the current user
 */
public struct GroceryList: Codable, Hashable {
  var id: String? = ""
  let name: String
  let icon: String
  let color: String
  let creator: DocumentReference
  var creatorObj: User?
  let sharedToUsers: [DocumentReference]
  var sharedToUsersObj: [User]? = []
  var sharedWithCurrentUser: Bool? = false
  
  /**
    Use to remove data that we only use for FE
   
    - returns:
      A dictionary of data that do not contain data we do not need
   */
  func getCleanDictionary() -> [String: Any] {
    return [
      "name" : name,
      "icon": icon,
      "color": color,
      "creator": creator,
      "sharedToUsers": sharedToUsers
    ]
  }
}

public struct ListItem: Codable, Hashable {
  
}
