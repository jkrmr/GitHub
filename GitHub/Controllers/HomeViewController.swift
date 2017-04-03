//
//  HomeViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  var repositories = [Repository]()

  override func viewDidLoad() {
    super.viewDidLoad()

    GitHubAPI.shared.listRepositories { json in
      guard let json = json else { return }

      for entry in json {
        guard let repo = Repository(json: entry) else { continue }
        self.repositories.append(repo)
      }

      print(self.repositories.count)
    }
  }
}
