//
//  RoundedEdgeImageView.swift
//  GitHub
//
//  Created by Jake Romer on 4/4/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class RoundedEdgeImageView: UIImageView {
  override var bounds: CGRect {
    get {
      return super.bounds
    }
    set {
      super.bounds = newValue
      setNeedsLayout()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.width / 20
    clipsToBounds = true
  }
}
