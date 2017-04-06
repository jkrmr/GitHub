//
//  AuthenticationViewController.swift
//  GitHub
//
//  Created by Jake Romer on 4/3/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import SafariServices
import UIKit

class AuthenticationViewController: UIViewController, SFSafariViewControllerDelegate {
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  var safari: SFSafariViewController!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let authRequest = GitHubAPI.shared.buildAuthenticationRequest(),
      let url = authRequest.url {
      safari = SFSafariViewController(url: url)
      safari.delegate = self
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    guard let safari = safari else { return }
    present(safari, animated: true, completion: nil)
  }

  func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
    loadingIndicator.stopAnimating()
  }
}
