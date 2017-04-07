//
//  ExploreViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/4/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit
import SafariServices

class ExploreViewController: UIViewController {
  // MARK: IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var segmentedControl: UISegmentedControl!

  var repositories = [Repository]() {
    didSet { tableView.reloadData() }
  }

  var users = [User]() {
    didSet { collectionView.reloadData() }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorInset = .zero

    let userCell = UINib(nibName: UserSearchResultCell.reuseID, bundle: nil)
    collectionView.register(userCell, forCellWithReuseIdentifier: UserSearchResultCell.reuseID)
  }

  // MARK: IBActions
  @IBAction func exploreToggle(_ sender: UISegmentedControl) {
    guard let segment = sender.titleForSegment(at: sender.selectedSegmentIndex)
      else { return }

    repositories.removeAll()
    users.removeAll()

    switch segment {
    case "Topics", "Repositories":
      UIView.animate(withDuration: 0.5, animations: {
        self.collectionView.alpha = 0
        self.tableView.alpha = 1
      })
    case "Users":
      UIView.animate(withDuration: 0.5, animations: {
        self.collectionView.alpha = 1
        self.tableView.alpha = 0
      })
    default:
      break
    }
  }
}

// MARK: Search Bar
// TODO: Add pull-to-refresh, pagination, loading indicator
extension ExploreViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchQuery = searchBar.text?.sanitized(),
      let segment = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
      else { return }

    switch segment {
    case "Topics":
      GitHubAPI.shared.searchTopics(query: searchQuery) { result in
        guard let items = result?["items"] as? [[String: AnyObject]] else { return }
        self.repositories.removeAll()

        for item in items {
          guard let repo = Repository(json: item) else { continue }
          self.repositories.append(repo)
        }
      }
    case "Repositories":
      GitHubAPI.shared.searchRepositories(query: searchQuery) { result in
        guard let items = result?["items"] as? [[String: AnyObject]] else { return }
        self.repositories.removeAll()

        for item in items {
          guard let repo = Repository(json: item) else { continue }
          self.repositories.append(repo)
        }
      }
    case "Users":
      GitHubAPI.shared.searchUsers(query: searchQuery) { result in
        guard let items = result?["items"] as? [[String: AnyObject]] else { return }
        self.users.removeAll()

        for item in items {
          guard let user = User(json: item) else { continue }
          self.users.append(user)
        }
      }
    default:
      break
    }
  }
}

// MARK: TableView
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = repositories[indexPath.row].fullName
    return cell
  }
}

// MARK: CollectionView
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchResultCell.reuseID,
                                                  for: indexPath) as! UserSearchResultCell
    cell.user = users[indexPath.row]
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedUser = users[indexPath.row]
    if let url = URL(string: selectedUser.urlHTML) {
      let safariVC = SFSafariViewController(url: url)
      present(safariVC, animated: true, completion: nil)
    }
  }
}

// MARK: CollectionView Flow Layout
extension ExploreViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 120, height: 120)
  }
}
