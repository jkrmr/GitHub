//
//  AuthenticationViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController, UIWebViewDelegate {
  @IBOutlet weak var webView: UIWebView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    webView.delegate = self

    if let authRequest = GitHubAPI.shared.buildAuthenticationRequest() {
      webView.loadRequest(authRequest)
    }
  }

  func webViewDidFinishLoad(_ webView: UIWebView) {
    loadingIndicator.stopAnimating()
  }
}
