//
//  GitHubAPI.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Foundation

typealias CollectionResponse = ([[String: AnyObject]]?) -> Void
typealias RecordResponse = ([String: AnyObject]?) -> Void

class GitHubAPI {
  static let shared = GitHubAPI()
  private init() {}

  let session = URLSession(configuration: .default)
  let apiBaseURL = "https://api.github.com"
  // var accessToken: String { return ENVVars.shared.get("access_token") }
  var accessToken: String {
    return UserDefaults().string(forKey: "github_access_token") ?? ""
  }

  /// List the authenticated user's repositories and yield the collection to
  /// completion handler COMPLETION
  func listRepositories(completion: @escaping CollectionResponse) {
    let path = "/user/repos"
    getJSON(path: path, completion: completion)
  }

  /// List the repositories for user with USERNAME and yield the collection to
  /// completion handler COMPLETION
  func listUserRepositories(username: String, completion: @escaping CollectionResponse) {
    let path = "/users/\(username)/repos"
    getJSON(path: path, completion: completion)
  }

  /// Send a GET request to the given URL, yield the parsed JSON
  /// to the completion handler as a dictionary.
  func getJSON(path: String, completion: @escaping CollectionResponse) {
    var dataTask: URLSessionDataTask?

    guard let url = URL(string: "\(apiBaseURL)\(path)?access_token=\(accessToken)")
      else { return print("Error: Malformed URL") }

    dataTask = session.dataTask(with: url) { (data, _, error) in
      if error != nil { return print("Error: Could not connect to \(url.absoluteString)") }

      if let data = data,
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
        let dict = json as? [[String: AnyObject]] {
        return completion(dict)
      }

      print("Error: Could not parse JSON response")
      if let data = data,
        let stringified = String(data: data, encoding: .utf8) {
        print("Data: \(stringified)")
      }
      return
    }

    dataTask?.resume()
  }

  func post(url urlString: String = "https://github.com/login/oauth/access_token", completion: @escaping RecordResponse) {
    guard let url = URL(string: urlString)
      else { return print("Error: Malformed URL") }

    let clientId = ENVVars.shared.get("client_id")
    let clientSecret = ENVVars.shared.get("client_secret")
    let oauthCode = UserDefaults().string(forKey: "github_oauth_code")
    let params = ["client_id": clientId, "client_secret": clientSecret,
                  "code": oauthCode, "redirect_uri": "github://authorized"]
    guard let paramData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
      else { return print("Error: Could not serialize auth request POST params") }

    // Prepare POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField:"Accept")
    request.setValue("application/json", forHTTPHeaderField:"Content-Type")
    request.timeoutInterval = 60.0
    request.httpBody = paramData

    var dataTask: URLSessionDataTask?

    dataTask = session.dataTask(with: request) { (data, _, error) in
      if error != nil { return print("Error: Could not connect to \(url.absoluteString)") }

      if let data = data,
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
        let dict = json as? [String: AnyObject] {
        return completion(dict)
      }

      print("Error: Could not parse JSON response")
      if let data = data,
        let stringified = String(data: data, encoding: .utf8) {
        print("Data: \(stringified)")
      }
      return
    }

    dataTask?.resume()
  }
}

enum GitHubApiError: Error {
  case authExtractingCodeError
}
