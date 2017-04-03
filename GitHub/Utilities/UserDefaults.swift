//
//  UserDefaults.swift
//  GitHub
//
//  Created by Jake Romer on 4/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Foundation

extension UserDefaults {
  func getAccessToken() -> String? {
    guard let token = UserDefaults.standard.string(forKey: "github_access_token")
      else { return nil }
    return token
  }

  func saveAccessToken(_ token: String) -> Bool {
    UserDefaults.standard.set(token, forKey: "github_access_token")
    return UserDefaults.standard.synchronize()
  }
}
