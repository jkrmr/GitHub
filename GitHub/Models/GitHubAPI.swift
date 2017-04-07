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

  // MARK: Authenticated user methods
  /// Query for the authenticated user's profile, yield the json to the
  /// completion handler COMPLETION
  func getAuthenticatedUser(completion: @escaping RecordResponse) {
    let path = "/user"
    getJSONRecord(path: path, completion: completion)
  }

  /// Query for the authenticated user's repositories and yield the collection to
  /// completion handler COMPLETION
  func listRepositories(completion: @escaping CollectionResponse) {
    let path = "/user/repos?type=owner,collaborator"
    getJSONCollection(path: path, completion: completion)
  }

  // MARK: Target user methods
  /// Query for user USERNAME's profile, yield the json to the completion 
  /// handler COMPLETION
  func getUser(username: String, completion: @escaping RecordResponse) {
    let path = "/users/\(username)"
    getJSONRecord(path: path, completion: completion)
  }

  /// Query for USERNAME's repositories and yield the collection to
  /// completion handler COMPLETION
  func listUserRepositories(username: String, completion: @escaping CollectionResponse) {
    let path = "/users/\(username)/repos"
    getJSONCollection(path: path, completion: completion)
  }

  // MARK: Activity streams
  func listActivityForUser(username: String, completion: @escaping CollectionResponse) {
    let path = "/users/\(username)/events"
    getJSONCollection(path: path, completion: completion)
  }

  // MARK: Search methods
  func searchRepositories(query: String, sort: SearchSort? = nil,
                          order: SearchOrder? = nil, completion: @escaping RecordResponse) {
    let path = "/search/repositories"
    let queryString = buildSearchQuery(query: query, sort: sort, order: order)
    getJSONRecord(path: "\(path)\(queryString)", completion: completion)
  }

  func searchUsers(query: String, sort: SearchSort? = nil,
                   order: SearchOrder? = nil, completion: @escaping RecordResponse) {
    let path = "/search/users"
    let queryString = buildSearchQuery(query: query, sort: sort, order: order)
    getJSONRecord(path: "\(path)\(queryString)", completion: completion)
  }

  func searchIssues(query: String, sort: SearchSort? = nil,
                    order: SearchOrder? = nil, completion: @escaping RecordResponse) {
    let path = "/search/issues"
    let queryString = buildSearchQuery(query: query, sort: sort, order: order)
    getJSONRecord(path: "\(path)\(queryString)", completion: completion)
  }

  // application/vnd.github.cloak-preview
  func searchCommits(query: String, sort: SearchSort? = nil,
                     order: SearchOrder? = nil, completion: @escaping RecordResponse) {
    let path = "/search/commits"
    let queryString = buildSearchQuery(query: query, sort: sort, order: order)
    getJSONRecord(path: "\(path)\(queryString)", completion: completion)
  }

  // application/vnd.github.mercy-preview+json
  func searchTopics(query: String, sort: SearchSort? = nil,
                    order: SearchOrder? = nil, completion: @escaping RecordResponse) {
    let path = "/search/repositories"
    let topics = query.scan("[:alnum:]+").map({ "topic:\($0)" }).joined(separator: "+")

    var queryString = "?q=\(topics)"
    if let sort = sort?.rawValue { queryString += "&sort=\(sort)" }
    if let order = order?.rawValue { queryString += "&order=\(order)" }

    getJSONRecord(path: "\(path)\(queryString)", completion: completion)
  }

  private func buildSearchQuery(query: String, sort: SearchSort? = nil, order: SearchOrder? = nil) -> String {
    let queryTerms = query.scan("[:word:]+").joined(separator: "+")

    // Build query string
    var queryString = "?q=\(queryTerms)"
    if let sort = sort?.rawValue { queryString += "&sort=\(sort)" }
    if let order = order?.rawValue { queryString += "&order=\(order)" }

    return queryString
  }

  // MARK: Generic request methods
  /// Send a Get request to the given PATH, yield the parsed json
  /// to the completion handler COMPLETION as an array of dictionaries.
  private func getJSONCollection(path: String, completion: @escaping CollectionResponse) {
    OperationQueue().addOperation {
      var dataTask: URLSessionDataTask?

      guard let accessToken = self.accessToken,
        let url = URL(string: "\(self.apiBaseURL)\(path)")
        else { return print("Error: Malformed URL") }

      var request = URLRequest(url: url)
      // Add preview header for topics data
      request.setValue("application/vnd.github.mercy-preview+json", forHTTPHeaderField: "Accept")
      request.setValue("token \(accessToken)", forHTTPHeaderField: "Authorization")

      dataTask = self.session.dataTask(with: request) { (data, _, error) in
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

  /// Send a Get request to the given PATH, yield the parsed json
  /// to the completion handler COMPLETION as a dictionary.
  private func getJSONRecord(path: String, completion: @escaping RecordResponse) {
    OperationQueue().addOperation {
      var dataTask: URLSessionDataTask?

      guard let accessToken = self.accessToken,
        let url = URL(string: "\(self.apiBaseURL)\(path)")
        else { return print("Error: Malformed URL") }

      var request = URLRequest(url: url)
      // Add preview header for topics data
      request.setValue("application/vnd.github.mercy-preview+json", forHTTPHeaderField: "Accept")
      request.setValue("token \(accessToken)", forHTTPHeaderField: "Authorization")

      dataTask = self.session.dataTask(with: request) { (data, _, error) in
        if error != nil { return print("Error: Could not connect to \(url.absoluteString)") }

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
          // TODO: If "message" == "Bad credentials", display alert,
          // redirect to login
        }
        return
      }

      dataTask?.resume()
    }
  }

  /// Send a Post request with the given request object REQUEST,
  /// yielding the response json to the completion handler
  /// COMPLETION as a dictionary.
  private func post(request: URLRequest, completion: @escaping RecordResponse) {
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

  // MARK: Authentication, Authorization
  /// Build a URLRequest for requesting an authentication code
  func buildAuthenticationRequest() -> URLRequest? {
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

  /// Send a Post request to the api authorization url with "code" AUTHCODE,
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

  // MARK: enums for API request options
  enum SearchSort: String {
    case stars = "stars"
    case forks = "forks"
    case updated = "updated"
  }

  enum SearchOrder: String {
    case ascending = "asc"
    case descending = "desc"
  }
}

enum GitHubApiError: Error {
  case authExtractingCodeError
}
