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

    tabBar.tintColor = UIColor.black
    tabBar.layer.borderWidth = 0.5
    tabBar.layer.borderColor = UIColor.lightGray.cgColor
    tabBar.clipsToBounds = true
  }

  override func viewWillLayoutSubviews() {
    let tabBarHeight: CGFloat = 40

    var tabFrame = tabBar.frame
    tabFrame.size.height = tabBarHeight
    tabFrame.origin.y = view.frame.size.height - tabBarHeight

    tabBar.frame = tabFrame
  }
}
