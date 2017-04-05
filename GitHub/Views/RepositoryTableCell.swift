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

  var repository: Repository! {
    didSet {
      repoName.text = repository.fullName
      repoDescription.text = repository.description
      repoLanguage.text = repository.language
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
