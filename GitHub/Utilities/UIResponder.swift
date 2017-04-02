//
//  UIResponder.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

extension UIResponder {
  /**
   Return the string representation of the given type name.
   For types that inherit from UIResponder.
   Used to consistify reuse identifiers.
   
   - Returns: String

   Example
   =======

   HomeViewController.reuseID
   
   //=> "HomeViewController"
   */
  static var reuseID: String {
    return String(describing: self)
  }
}
