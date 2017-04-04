//
//  ExploreViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/4/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
  // MARK: IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!

  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self
    tableView.delegate = self
    tableView.dataSource = self
  }

  // MARK: IBActions
  @IBAction func exploreToggle(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      UIView.animate(withDuration: 0.5, animations: {
        self.collectionView.alpha = 0
        self.tableView.alpha = 1
      })
    case 1:
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
extension ExploreViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("text editing ended")
  }
}

// MARK: TableView
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    return cell
  }
}

// MARK: CollectionView
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "container", for: indexPath)
    return cell
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
