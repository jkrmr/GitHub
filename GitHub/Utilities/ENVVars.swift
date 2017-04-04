//
//  ENVVars.swift
//  GitHub
//
//  Created by Jake Romer on 4/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Foundation

/// Interface to ENV vars JSON file
struct ENVVars {
  static let shared = ENVVars()
  private init() {}

  /// Get the String keyed by VARIABLE in env.json
  func get(_ variable: String) -> String {
    guard let path = Bundle.main.url(forResource: "env", withExtension: "json"),
      let data = try? Data(contentsOf: path),
      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
      let dict = json as? [String: String],
      let token = dict[variable]
      else { return "" }
    return token
  }
}
