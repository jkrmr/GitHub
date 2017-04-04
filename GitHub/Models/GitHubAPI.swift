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
  let apiAuthorizationURL = "https://github.com/login/oauth/access_token"
  let apiOAuthURL = "https://github.com/login/oauth/authorize"

  let clientID = ENVVars.shared.get("client_id")
  let clientSecret = ENVVars.shared.get("client_secret")
  var accessToken: String? { return UserDefaults.standard.getAccessToken() }

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
    OperationQueue().addOperation {
      var dataTask: URLSessionDataTask?

      guard let accessToken = self.accessToken,
        let url = URL(string: "\(self.apiBaseURL)\(path)?access_token=\(accessToken)")
        else { return print("Error: Malformed URL") }

      dataTask = self.session.dataTask(with: url) { (data, _, error) in
        if error != nil { return print("Error: Could not connect to \(url.absoluteString)") }

        if let data = data,
          let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
          let dict = json as? [[String: AnyObject]] {
          OperationQueue.main.addOperation { completion(dict) }
          return
        }

        print("Error: Could not parse JSON response")
        if let data = data,
          let stringified = String(data: data, encoding: .utf8) {
          print("Data: \(stringified)")
          // TODO: If "message" == "Bad credentials", display alert,
          // redirect to login
        }
        return
      }

      dataTask?.resume()
    }
  }

  /// Build a URLRequest for requesting an authentication code
  func getAuthenticationRequest() -> URLRequest? {
    let scopes = [
      "repo",
      "user",
      "delete_repo",
      "gist",
      "read:org"
      ].joined(separator: ",")
    let redirectURI = "github://auth?duration=permanent&scope=\(scopes)"

    guard let url = URL(string: "\(apiOAuthURL)?client_id=\(clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)")
      else { return nil }

    return URLRequest(url: url)
  }

  /// Send a POST request to the api authorization URL with `code` AUTHCODE,
  /// yielding the response JSON to the completion handler COMPLETION as a dictionary.
  func postAuthorization(authCode: String, completion: @escaping RecordResponse) {
    guard let url = URL(string: apiAuthorizationURL)
      else { return print("Error: Malformed URL") }

    let params = ["client_id": clientID, "client_secret": clientSecret,
                  "code": authCode, "redirect_uri": "github://auth"]

    guard let paramData = try? JSONSerialization.data(withJSONObject: params)
      else { return print("Error: Could not serialize auth request POST params") }

    // Prepare POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField:"Accept")
    request.setValue("application/json", forHTTPHeaderField:"Content-Type")
    request.timeoutInterval = 60.0
    request.httpBody = paramData

    post(request: request, completion: completion)
  }

  /// Send a POST request with the given request object REQUEST,
  /// yielding the response JSON to the completion handler
  /// COMPLETION as a dictionary.
  func post(request: URLRequest, completion: @escaping RecordResponse) {
    OperationQueue().addOperation {
      var dataTask: URLSessionDataTask?

      dataTask = self.session.dataTask(with: request) { (data, _, error) in
        if error != nil {
          return print("Error: Could not connect to \(request.url?.absoluteString ?? "no url")")
        }

        if let data = data,
          let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
          let dict = json as? [String: AnyObject] {
          OperationQueue.main.addOperation { completion(dict) }
          return
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
}

enum GitHubApiError: Error {
  case authExtractingCodeError
}
