//
//  ListsObv.swift
//  Grocery and Me
//
//  Created by 春音 on 24/4/22.
//

import FirebaseFirestore


class ListsObv: ObservableObject {
  let collectionList = Firestore.firestore().collection(COL_LISTS)
  let db = Firestore.firestore()
  @Published var createdLists: [GroceryList]? = nil
  @Published var sharedLists: [GroceryList]? = nil
  var currentUser: DocumentReference? = nil
  var createdListListener: ListenerRegistration? = nil
  var sharedListListener: ListenerRegistration? = nil
  var usersList: [String:User] = [:]
  
  init(_ uid: String = "") {
    stopListen()
  }
  
  /**
    Method to used to create test data for UI
   
    - parameters:
      - haveData: the logged in user's userid
   
    - returns: Nothing
   */
  init(haveData: Bool){
    let creator = User(id: "", name: "はるは", email: "", profileImage: "07bc29c3cb0bad11016155ffebe29b75")
    if haveData {
      createdLists = [
        GroceryList(name: "こうせいが好き",
                    icon: "https://pbs.twimg.com/profile_images/1499869763140341762/Z1lMYx6m_400x400.jpg",
                    color: "#15A0B8",
                    creator: db.document("Users/usr1"),
                    creatorObj: creator,
                    sharedToUsers: []),
        GroceryList(name: "こうせいが大好き",
                    icon: "",
                    color: "#0079FF",
                    creator: db.document("Users/usr2"),
                    creatorObj: creator,
                    sharedToUsers: [])
      ]
      sharedLists = [
        GroceryList(name: "航成が好き",
                    icon: "",
                    color: "#FB7C13",
                    creator: db.document("Users/usr3"),
                    creatorObj: creator,
                    sharedToUsers: []),
        GroceryList(name: "航成が大好き",
                    icon: "",
                    color: "#1FC896",
                    creator: db.document("Users/usr4"),
                    creatorObj: creator,
                    sharedToUsers: [])
      ]
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
  func listen(_ uid: String) {
    stopListen()
    if (uid == "") { return }
    currentUser = db.document(String(format: "%@/%@", COL_USERS, uid))
    if createdListListener == nil {
      createdListListener = collectionList
        .whereField("creator", isEqualTo: currentUser!)
        .addSnapshotListener {(querySnapshot, error) in
          
        self.parseListData(querySnapshot, error) { list in
          self.createdLists = list
        }
      }
    }
    if sharedListListener == nil {
      sharedListListener = collectionList
        .whereField("sharedToUsers", arrayContains: currentUser!)
        .addSnapshotListener {(querySnapshot, error) in
          
        self.parseListData(querySnapshot, error, isSharedList: true) { list in
          self.sharedLists = list
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
                             isSharedList: Bool = false,
                             completion: @escaping ([GroceryList]) -> Void) {
    guard let snapshot = querySnapshot else {
      print("Error fetching snapshots: \(error!)")
      return completion([])
    }
    var tempList: [GroceryList] = []
    tempList.reserveCapacity(snapshot.documents.count)
    var needUserInfoList: [DocumentReference] = []
    
    for (_, document) in snapshot.documents.enumerated() {
      do {
        var list = try document.data(as: GroceryList.self)
        list.id = document.documentID
        list.sharedWithCurrentUser = isSharedList
        tempList.append(list)
        needUserInfoList.append(list.creator)
      } catch (let error) {
        print("Error decoding List Object: \(error)")
      }
    }
    tempList = tempList.sorted(by: { $0.name < $1.name })
    
    getListOfUsers(needUserInfoList) { _ in
      for (i, listData) in tempList.enumerated() {
        if let user = self.usersList[listData.creator.documentID] {
          tempList[i].creatorObj = user
        }
      }
      completion(tempList)
    }
  }
  
  /**
    Stop listing to server and reset all data
   */
  func stopListen() {
    createdListListener?.remove()
    sharedListListener?.remove()
    createdListListener = nil
    sharedListListener = nil
    currentUser = nil
  }
  
  /**
    Get list of users that are not in the current list and add to arr if needed
   
    - parameters:
      - users: the list of users we need to get
      - completion: an array of `User` to the user object
   
    - returns: Nothing
   */
  func getListOfUsers(_ users:[DocumentReference],
                      completion: @escaping ([User]) -> Void) {
    let group = DispatchGroup()
    var foundUsers: [User] = []
    foundUsers.reserveCapacity(users.count)
    
    for ref in users {
      if let user = usersList[ref.documentID] {
        foundUsers.append(user)
      } else {
        group.enter()
        ref.getDocument(as: User.self) { result in
          switch result {
          case .success(let user):
            self.usersList[ref.documentID] = user
            foundUsers.append(user)
            break
          case .failure(let error):
            print("Error decoding user: \(error)")
          }
          group.leave()
        }
      }
    }
    
    group.notify(queue: .main) {
      completion(foundUsers)
    }
  }
  
  /**
    Get user's `DocumentReference` by email
   
    - parameters:
      - emails: array of emails
      - excludeOwnself: will not append if email = current user email
      - completion: array of `DocumentReference` if users are found
   
    - returns: Nothing
   */
  func checkAndGetEmails(_ emails: [String],
                         excludeOwnself: Bool = false,
                         completion: @escaping ([DocumentReference]) -> Void) {
    if (emails.count == 0) {
      return completion([])
    }
    
    var foundRef: [DocumentReference] = []
    foundRef.reserveCapacity(emails.count)
    let group = DispatchGroup()
    
    for email in emails {
      let email = email.lowercased()
      
      var found = false
      if excludeOwnself {
        if let currentUserData = usersList[currentUser!.documentID], currentUserData.email == email {
          continue
        }
      }
      
      for (_, user) in usersList {
        if user.email == email {
          foundRef.append(user.getDbBRef())
          found = true
          break
        }
      }
      
      if (!found) {
        group.enter()
        db.collection(COL_USERS)
          .whereField("email", isEqualTo: email.lowercased())
          .getDocuments() {(querySnapshot, err) in
          
          if let err = err {
            print("Error getting documents: \(err)")
          } else {
            for document in querySnapshot!.documents {
              foundRef.append(document.reference)
              do {
                let user = try document.data(as: User.self)
                self.usersList[document.documentID] = user
              } catch (let error) {
                print("Error decoding User Object: \(error)")
              }
            }
          }
          group.leave()
        }
      }
    }
    
    group.notify(queue: .main) {
      completion(foundRef)
    }
  }
  
  /**
    Add a list to the database
   
    - parameters:
      - name: the name of the list
      - icon: the icon of the list (if none is provided a default icon is used, if it is a sharing list the creator's profile picture is used)
      - color: the theme color of the list
      - sharedUsers: an array of emails that the list is to be shared with
      - completion: will return if the list has been successfully added
   
    - returns: Nothing
   */
  func addList(name: String,
               icon: String,
               color: String,
               sharedUsers: [String],
               completion:@escaping (Bool) -> Void) {
    checkAndGetEmails(sharedUsers, excludeOwnself: true) { users in
      let newList = GroceryList(name: name,
                                icon: icon,
                                color: color,
                                creator: self.currentUser!,
                                creatorObj: nil,
                                sharedToUsers: users)
      
      self.collectionList.addDocument(data: newList.getCleanDictionary()) { err in
        if let err = err {
          print("Error adding document: \(err)")
          completion(false)
        } else {
          completion(true)
        }
      }
    }
  }
  
  /**
    Edit a list in the database
   
    - parameters:
      - listData: the exiting data in the database
      - name: the name of the list
      - icon: the icon of the list (if none is provided a default icon is used, if it is a sharing list the creator's profile picture is used)
      - color: the theme color of the list
      - sharedUsers: an array of emails that the list is to be shared with
      - completion:will return if the list has been successfully edited
   
    - returns: Nothing
   */
  func editList(listData: GroceryList,
                name: String,
                icon: String,
                color: String,
                sharedUsers: [String],
                completion:@escaping (Bool) -> Void) {
    checkAndGetEmails(sharedUsers, excludeOwnself: true) { users in
      // Check diff
      var diff: [String:Any] = [:]
      if (name != listData.name) { diff["name"] = name }
      if (icon != listData.icon) { diff["icon"] = icon }
      if (color != listData.color) { diff["color"] = color }
      if (users.count != listData.sharedToUsers.count) {
        diff["sharedToUsers"] = users
      } else {
        for passedUserEmail in sharedUsers {
          var found = false
          for existingUser in listData.sharedToUsersObj! {
            if existingUser.email == passedUserEmail {
              found = true
            }
          }
          if !found {
            diff["sharedToUsers"] = users
            break;
          }
        }
      }
      
      if diff.count > 0 {
        self.collectionList.document(listData.id!).updateData(diff) { err in
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
  }
  
  /**
    Delete the list (only by creator)
   
    - parameters:
      - id: the ID of the list
      - completion: will return if the list has been successfully deleted
   
    - returns: Nothing
   */
  func deleteList(_ id: String, completion:@escaping (Bool) -> Void) {
    self.collectionList.document(id).delete() {err in
      if let err = err {
        print("Error removing document: \(err)")
        completion(false)
      } else {
        print("Document successfully removed!")
        completion(true)
      }
    }
  }
  
  /**
    Remove oneself from the shared list  (only by creator)
   
    - parameters:
      - id: the ID of the list
      - sharedUsers: the current list of shared users
      - completion: will return if the list has been successfully deleted
   
    - returns: Nothing
   */
  func leaveList(_ id: String, sharedUsers: [DocumentReference], completion:@escaping (Bool) -> Void) {
    var users: [DocumentReference] = []
    users.reserveCapacity(sharedUsers.count-1)
    
    for user in sharedUsers {
      if user.path != currentUser!.path {
        users.append(user)
      }
    }
    
    self.collectionList.document(id).updateData(["sharedToUsers" : users]) { err in
      if let err = err {
        print("Error editing document: \(err)")
        completion(false)
      } else {
        completion(true)
      }
    }
  }
}
