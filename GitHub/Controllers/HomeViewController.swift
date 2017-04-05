//
//  HomeViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  // MARK: IBOutlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  // MARK: Properties
  var allRepositories = [Repository]() {
    didSet { tableView.reloadData() }
  }
  var filteredRepositories = [Repository]()
  var inSearchMode: Bool = false
  var repositories: [Repository] {
    if inSearchMode { return filteredRepositories }
    return allRepositories
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "github_logo"))
    navigationItem.titleView = logoImageView

    searchBar.delegate = self
    searchBar.returnKeyType = .done

    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero

    let repoNib = UINib(nibName: RepositoryTableCell.reuseID, bundle: nil)
    tableView.register(repoNib, forCellReuseIdentifier: RepositoryTableCell.reuseID)

    loadRepositories()
  }

  func loadRepositories() {
    GitHubAPI.shared.listRepositories { json in
      guard let json = json else { return }

      for entry in json {
        guard let repo = Repository(json: entry) else { continue }
        self.allRepositories.append(repo)
      }
      self.loadingIndicator.stopAnimating()
      self.loadingIndicator.isHidden = true
    }
  }
}

// MARK: TableView
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableCell.reuseID,
                                             for: indexPath) as! RepositoryTableCell
    cell.repository = repositories[indexPath.row]
    
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let repository = repositories[indexPath.row]
    tableView.deselectRow(at: indexPath, animated: false)
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

// MARK: Search Bar
extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == nil || searchBar.text == "" {
      inSearchMode = false
    } else {
      inSearchMode = true
      let searchTerm = searchText.lowercased()
      filteredRepositories = allRepositories.filter { $0.name.lowercased().range(of: searchTerm) != nil }
    }
    tableView.reloadData()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}
