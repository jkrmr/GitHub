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

  @IBOutlet weak var repoName: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let repository = repository {
      repoName.text = repository.name
    }
  }
}
