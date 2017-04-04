//
//  String.swift
//  GitHub
//
//  Created by Jake Romer on 4/4/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Foundation

extension String {
  func scan(_ regex: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: regex)
      let nsString = self as NSString
      let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
      return results.map { nsString.substring(with: $0.range)}
    } catch let error {
      print("Invalid regular expression: \(error.localizedDescription)")
      return []
    }
  }
}
