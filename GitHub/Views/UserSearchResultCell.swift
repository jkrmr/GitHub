//
//  UserSearchResultCell.swift
//  GitHub
//
//  Created by Jake Romer on 4/4/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class UserSearchResultCell: UICollectionViewCell {
  @IBOutlet weak var username: UILabel!

  var user: User? {
    didSet {
      username.text = user?.login
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
