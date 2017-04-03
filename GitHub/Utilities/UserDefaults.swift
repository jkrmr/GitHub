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
    let githubAccessTokenKey = "github_access_token"
    guard let token = UserDefaults.standard.string(forKey: githubAccessTokenKey)
      else { return nil }
    return token
  }

  func saveAccessToken(_ token: String) -> Bool {
    let githubAccessTokenKey = "github_access_token"
    UserDefaults.standard.set(token, forKey: githubAccessTokenKey)
    return UserDefaults.standard.synchronize()
  }

  func removeAccessToken() -> Bool {
    let githubAccessTokenKey = "github_access_token"
    UserDefaults.standard.removeObject(forKey: githubAccessTokenKey)
    return UserDefaults.standard.synchronize()
  }
}
