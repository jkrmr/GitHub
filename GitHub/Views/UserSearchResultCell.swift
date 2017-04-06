//
//  UserSearchResultCell.swift
//  GitHub
//
//  Created by Jake Romer on 4/4/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class UserSearchResultCell: UICollectionViewCell {
  @IBOutlet weak var userAvatarImage: RoundedEdgeImageView!

  var user: User? {
    didSet {
      guard let url = user?.urlAvatar else { return }
      UIImage.fromURL(url: url) { image in
        self.userAvatarImage.image = image
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
