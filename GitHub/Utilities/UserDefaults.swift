//
//  UserDefaults.swift
//  GitHub
//
//  Created by Jake Romer on 4/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Foundation

extension UserDefaults {
  private var githubAccessTokenKey: String {
    return "github_access_token"
  }

  func getAccessToken() -> String? {
    guard let token = UserDefaults.standard.string(forKey: githubAccessTokenKey)
      else { return nil }
    return token
  }

  func saveAccessToken(_ token: String) -> Bool {
    UserDefaults.standard.set(token, forKey: githubAccessTokenKey)
    return UserDefaults.standard.synchronize()
  }

  func removeAccessToken() -> Bool {
    UserDefaults.standard.removeObject(forKey: githubAccessTokenKey)
    return UserDefaults.standard.synchronize()
  }
}
