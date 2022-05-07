//
//  Notification.swift
//  Grocery and Me
//
//  Created by 春音 on 3/5/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFunctions
import FirebaseMessaging


/**
  Subscribe to the current user to a topic
 
  - parameters:
    - topic: the topic to subscribe to
 */
func subscribe(to topic: String) {
  Messaging.messaging().subscribe(toTopic: topic)
}

/**
  Unsubscribe to the current user to a topic
 
  - parameters:
    - topic: the topic to unsubscribe from
 */
func unsubscribe(from topic: String) {
  Messaging.messaging().unsubscribe(fromTopic: topic)
}

/**
  Send a notification to other users in the list
 
  - parameters:
    - id: the ID of the list
    - listName: the name of the list
    - listPicture: the picture used in the list as icon
    - creator: the creator of the list
    - subcribedUsers: the users that the list is shared with
 
  This will call the firebase function to send notification to users.
 
  This function will not call the remote function if any of the following
  is met:
    1. The list is not shared with any others
    2. The notificaiton has be sent in `NOTI_MIN_TIME_BETWEEN_NOTI` amount of time
 
  The remote function will filter the current user using auth to prevent
  the current user from receiving the notification.
 */
func sendUpdatedListNoti(_ id: String,
                         listName: String,
                         listPicture: String = "",
                         creator: DocumentReference,
                         subcribedUsers: [DocumentReference]) {
  if subcribedUsers.count == 0 { return }
  
  // Check if x mins passed before resending noti
  let notiKey = "noti.\(id)"
  if let prevDate = UserDefaults.standard.value(forKey: notiKey) as? NSDate {
    
    if prevDate.timeIntervalSinceNow > NOTI_MIN_TIME_BETWEEN_NOTI {
      print("Time interval too short \(prevDate.timeIntervalSinceNow)")
      return
    }
  }
  UserDefaults.standard.set(NSDate(), forKey: notiKey)
  
  lazy var functions = Functions.functions()
  var allUsers: [String] = [creator.documentID]
  allUsers.reserveCapacity(subcribedUsers.count + 1)
  for user in subcribedUsers {
    allUsers.append(user.documentID)
  }
  
  let payload = [
    "listName": listName,
    "subscribedUsers": allUsers,
    "picture": listPicture,
  ] as [String : Any]
  
  functions.httpsCallable("sendEditListNoti").call(payload){ result, error in
    if let error = error as NSError? {
      print("Error sending edit list noti: \(error.localizedDescription)")
      UserDefaults.standard.removeObject(forKey: notiKey)
    }
    if let data = result?.data as? [String: Any] {
      print(data)
    }
  }
}
