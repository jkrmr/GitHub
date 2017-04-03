//
//  HomeViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  @IBOutlet weak var repositoriesTableView: UITableView!

  var repositories = [Repository]() {
    didSet { repositoriesTableView.reloadData() }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    repositoriesTableView.delegate = self
    repositoriesTableView.dataSource = self

    let repoNib = UINib(nibName: RepositoryTableCell.reuseID, bundle: nil)
    repositoriesTableView.register(repoNib, forCellReuseIdentifier: RepositoryTableCell.reuseID)

    loadRepositories()
  }

  func loadRepositories() {
    OperationQueue().addOperation {
      GitHubAPI.shared.listRepositories { json in
        guard let json = json else { return }

        for entry in json {
          guard let repo = Repository(json: entry) else { continue }
          OperationQueue.main.addOperation {
            self.repositories.append(repo)
          }
        }
      }
    }
  }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = repositoriesTableView.dequeueReusableCell(withIdentifier: RepositoryTableCell.reuseID,
                                                            for: indexPath) as? RepositoryTableCell {
      cell.repository = repositories[indexPath.row]
      return cell
    } else {
      return RepositoryTableCell()
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    repositoriesTableView.deselectRow(at: indexPath, animated: false)
    performSegue(withIdentifier: RepositoryViewController.reuseID, sender: repository)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == RepositoryViewController.reuseID,
      let controller = segue.destination as? RepositoryViewController,
      let repository = sender as? Repository {
      controller.repository = repository
      return
    }
  }
}
