//
//  AppDelegate.swift
//  Grocery and Me
//
//  Created by 春音 on 16/4/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    Firestore.firestore()
    
    // Will be used everytime so init here will be faster
    CATEGORIES = [
      ItemCategory(icon: "wine-glass",
                   key: "CATEGORY_ALCOHOL"),
      ItemCategory(icon: "baby",
                   key: "CATEGORY_BABY"),
      ItemCategory(icon: "bread-loaf",
                   key: "CATEGORY_BAKERY"),
      ItemCategory(icon: "cup-straw",
                   key: "CATEGORY_BEVERAGES"),
      ItemCategory(icon: "pancakes",
                   key: "CATEGORY_BREAKFAST"),
      ItemCategory(icon: "shirt",
                   key: "CATEGORY_CLOTHES"),
      ItemCategory(icon: "can-food",
                   key: "CATEGORY_CANNED_FOOD"),
      ItemCategory(icon: "salt-shaker",
                   key: "CATEGORY_CONDIMENTS"),
      ItemCategory(icon: "cauldron",
                   key: "CATEGORY_COOKING"),
      ItemCategory(icon: "glass",
                   key: "CATEGORY_DAIRY"),
      ItemCategory(icon: "sausage",
                   key: "CATEGORY_DELI"),
      ItemCategory(icon: "ice-cream",
                   key: "CATEGORY_FROZEN"),
      ItemCategory(icon: "bowl-rice",
                   key: "CATEGORY_GRAINS"),
      ItemCategory(icon: "capsules",
                   key: "CATEGORY_HEALTH"),
      ItemCategory(icon: "toilet-paper-under",
                   key: "CATEGORY_HOUSEHOLD"),
      ItemCategory(icon: "meat",
                   key: "CATEGORY_MEAT"),
      ItemCategory(icon: "dog-leashed",
                   key: "CATEGORY_PET"),
      ItemCategory(icon: "apple-whole",
                   key: "CATEGORY_PRODUCE"),
      ItemCategory(icon: "fish",
                   key: "CATEGORY_SEAFOOD"),
      ItemCategory(icon: "cookie-bite",
                   key: "CATEGORY_SNACKS"),
    ]
    CATEGORIES = CATEGORIES.sorted(by: { $0.name < $1.name })
    CATEGORIES.append(
      ItemCategory(icon: "cubes-stacked",
                   key: "CATEGORY_OTHER")
    )
    CATEGORIES_DICT.reserveCapacity(CATEGORIES.count)
    for category in CATEGORIES {
      CATEGORIES_DICT[category.key] = category
    }
    
    return true
  }
}
