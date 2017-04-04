//
//  ShortTabBarController.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class ShortTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tabBar.layer.borderWidth = 0.5
    self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
    self.tabBar.clipsToBounds = true
  }

  override func viewWillLayoutSubviews() {
    var tabFrame = self.tabBar.frame
    // - 40 is editable , the default value is 49 px,
    tabFrame.size.height = 40
    tabFrame.origin.y = self.view.frame.size.height - 40
    self.tabBar.frame = tabFrame
  }
}
