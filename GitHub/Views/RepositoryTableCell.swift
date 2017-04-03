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

  
  var repository: Repository! {
    didSet {
      repoName.text = repository.fullName
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
