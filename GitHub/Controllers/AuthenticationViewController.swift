//
//  AuthenticationViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
  @IBOutlet weak var webView: UIWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    if let authRequest = GitHubAPI.shared.getAuthenticationRequest() {
      webView.loadRequest(authRequest)
    }
  }
}
