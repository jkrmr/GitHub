//
//  RepositoryViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit
import SafariServices

class RepositoryViewController: UIViewController {
  var repository: Repository?

  @IBOutlet weak var repoDetailsContainer: UIView!
  @IBOutlet weak var repoName: UILabel!
  @IBOutlet weak var repoDescription: UILabel!
  @IBOutlet weak var repoLanguage: UILabel!
  @IBOutlet weak var repoStars: UILabel!
  @IBOutlet weak var repoForks: UILabel!
  @IBOutlet weak var repoCreatedAt: UILabel!
  @IBOutlet weak var repoIsFork: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    repoDetailsContainer.layer.borderColor = UIColor.lightGray.cgColor
    repoDetailsContainer.layer.borderWidth = 0.5

    if let repository = repository {
      repoName.text = repository.name
      repoDescription.text = repository.description
      repoLanguage.text = repository.language
      repoStars.text = "Stars: \(repository.stargazersCount)"
      repoForks.text = "Forks: \(repository.forksCount)"
      repoIsFork.text = repository.isFork ? "fork of" : ""
      repoCreatedAt.text = "Created: \(repository.createdAt.toString())"
    }
  }

  @IBAction func repoNameWasTapped(_ sender: UITapGestureRecognizer) {
    if let urlString = repository?.urlHTML, let url = URL(string: urlString) {
      let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
      present(safariVC, animated: true, completion: nil)
    }
  }
}
