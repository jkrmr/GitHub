//
//  RepositoryViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

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
      repoStars.text = "\(repository.stargazersCount)"
      repoForks.text = "\(repository.forksCount)"
      repoIsFork.text = repository.isFork ? "fork" : ""
      repoCreatedAt.text = repository.createdAt.toString()
    }
  }
}
