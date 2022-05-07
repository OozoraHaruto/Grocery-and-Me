//
//  UserHelper.swift
//  Grocery and Me
//
//  Created by 春音 on 7/5/22.
//

func generatePicLink(_ emailHash: String, size: Int = 200) -> String {
  return String(format: "https://www.gravatar.com/avatar/%@?s=%d&f=retro", emailHash, size);
}
