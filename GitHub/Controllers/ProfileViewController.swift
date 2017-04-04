//
//  ProfileViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  @IBOutlet weak var navItem: UINavigationItem!
  @IBOutlet weak var userAvatar: UIImageView!
  @IBOutlet weak var userDisplayName: UILabel!
  @IBOutlet weak var userUsername: UILabel!
  @IBOutlet weak var userProfileContainer: UIView!

  var user: User? {
    didSet {
      guard let user = user else { return }
      getActivityStream(user: user)
      navItem.title = user.login
      userDisplayName.text = user.name
      userUsername.text = user.login

      if let url = user.urlAvatar {
        UIImage.fromURL(url: url) { (image) in
          self.userAvatar.image = image
        }
      }
    }
  }

  // var activityStream:

  override func viewDidLoad() {
    super.viewDidLoad()

    userProfileContainer.layer.borderColor = UIColor.lightGray.cgColor
    userProfileContainer.layer.borderWidth = 0.5

    GitHubAPI.shared.getAuthenticatedUser { json in
      guard let json = json else { return }
      self.user = User(json: json)
    }
  }

  func getActivityStream(user: User) {
    GitHubAPI.shared.listActivityForUser(username: user.login) { _ in
    }
  }
}
