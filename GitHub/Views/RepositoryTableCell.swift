//
//  RepositoryTableCell.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class RepositoryTableCell: UITableViewCell {
  @IBOutlet weak var repoName: UILabel!
  @IBOutlet weak var repoDescription: UILabel!
  @IBOutlet weak var repoLanguage: UILabel!
  @IBOutlet weak var starsContainer: UIView!
  @IBOutlet weak var starsCount: UILabel!
  @IBOutlet weak var forksContainer: UIView!
  @IBOutlet weak var forksCount: UILabel!

  var repository: Repository! {
    didSet {
      repoName.text = repository.fullName
      repoDescription.text = repository.description
//      repoLanguage.text = repository.language
//
//      if repository.stargazersCount > 0 {
//        starsCount.text = "\(repository.stargazersCount)"
//        starsContainer.isHidden = false
//      } else {
//        starsContainer.isHidden = true
//      }
//
//      if repository.forksCount > 0 {
//        forksCount.text = "\(repository.forksCount)"
//        forksContainer.isHidden = false
//      } else {
//        forksContainer.isHidden = true
//      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
