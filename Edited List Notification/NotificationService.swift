//
//  NotificationService.swift
//  Edited List Notification
//
//  Created by 春音 on 3/5/22.
//

import UserNotifications
import FirebaseMessaging

class NotificationService: UNNotificationServiceExtension {

  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?

  override func didReceive(_ request: UNNotificationRequest,
                           withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
    guard let bestAttemptContent = bestAttemptContent else { return }
    
    if let action = bestAttemptContent.userInfo["action"] as? String {
      if action == "EditList" {
        let userName = (bestAttemptContent.userInfo["usersName"] ?? "UNKOWN_USER".localized) as! String
        let listName = (bestAttemptContent.userInfo["listName"] ?? "NOTI_UNKOWN_LIST".localized) as! String
        bestAttemptContent.title = "NOTI_EDIT_LIST_HEADER".localized
        bestAttemptContent.body = String.localizedStringWithFormat("NOTI_EDIT_LIST_BODY".localized, userName, listName)
      }
    }
    
    FIRMessagingExtensionHelper().populateNotificationContent(
      bestAttemptContent,
      withContentHandler: contentHandler)
  }
  
  override func serviceExtensionTimeWillExpire() {
      // Called just before the extension will be terminated by the system.
      // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
      if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
          contentHandler(bestAttemptContent)
      }
  }

}
