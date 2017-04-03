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
    let oauthURL = "https://github.com/login/oauth/authorize"
    let clientID = ENVVars.shared.get("client_id")
    let scopes = ["repo"].joined(separator: " ")

    let url = URL(string: "\(oauthURL)?client_id=\(clientID)&scope=\(scopes)")!
    let req = URLRequest(url: url)
    webView.loadRequest(req)
  }
}
