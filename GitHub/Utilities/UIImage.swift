//
//  UIImage.swift
//  GitHub
//
//  Created by Jake Romer on 4/4/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

typealias ImageCompletion = (UIImage?) -> Void

extension UIImage {
  static func fromURL(url urlString: String, cacheKey: String? = nil, completion: @escaping ImageCompletion) {
    guard let url = URL(string: urlString) else { return completion(nil) }

    let returnToMain = { (_ image: UIImage?) in
      OperationQueue.main.addOperation { completion(image) }
    }

    OperationQueue().addOperation {
      guard let data = try? Data(contentsOf: url)
        else { return returnToMain(nil) }
      return returnToMain(UIImage(data: data))
    }
  }
}
