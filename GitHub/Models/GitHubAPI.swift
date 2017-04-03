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

  var accessToken: String {
    guard let path = Bundle.main.url(forResource: "env", withExtension: "json"),
      let data = try? Data(contentsOf: path),
      let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject],
      let token = json?["access_token"] as? String
      else { return "" }
    return token
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
}
