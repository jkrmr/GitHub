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
  @IBOutlet weak var repositorySearchBar: UISearchBar!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  var repositories = [Repository]() {
    didSet { repositoriesTableView.reloadData() }
  }

  var filteredRepositories = [Repository]()
  var inSearchMode: Bool = false

  var selectedRepositorySet: [Repository] {
    if inSearchMode { return filteredRepositories }
    return repositories
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    repositorySearchBar.delegate = self
    repositorySearchBar.returnKeyType = .done

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

        OperationQueue.main.addOperation {
          for entry in json {
            guard let repo = Repository(json: entry) else { continue }
            self.repositories.append(repo)
          }
          self.loadingIndicator.stopAnimating()
          self.loadingIndicator.isHidden = true
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
    return selectedRepositorySet.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = repositoriesTableView.dequeueReusableCell(withIdentifier: RepositoryTableCell.reuseID,
                                                            for: indexPath) as? RepositoryTableCell {
      cell.repository = selectedRepositorySet[indexPath.row]

      return cell
    } else {
      return RepositoryTableCell()
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let repository = selectedRepositorySet[indexPath.row]
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

extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == nil || searchBar.text == "" {
      inSearchMode = false
    } else {
      inSearchMode = true
      let searchTerm = searchText.lowercased()
      filteredRepositories = repositories.filter { $0.name.lowercased().range(of: searchTerm) != nil }
    }
    repositoriesTableView.reloadData()
  }
}
