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
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!

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
          self.loadingIndicator.stopAnimating()
        }
      }
    }
  }

  // var activityStream:

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorInset = .zero
    tableView.delegate = self
    tableView.dataSource = self

    userProfileContainer.layer.borderColor = UIColor.lightGray.cgColor
    userProfileContainer.layer.borderWidth = 0.5

    GitHubAPI.shared.getAuthenticatedUser { json in
      guard let json = json else { return }
      self.user = User(json: json)
    }
  }

  func getActivityStream(user: User) {
    GitHubAPI.shared.listActivityForUser(username: user.login) { _ in
      // TODO: Create Event models,
      // display relevant ones
      // Collect commit data for display of good ones
      // in medium
      // Collect likes on commits
    }
  }
}

// MARK: TableView
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Selected row number \(indexPath.row)")
  }
}
