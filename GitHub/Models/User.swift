//
//  User.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Foundation
import Gloss

struct User: Decodable {
  let id: Int
  let login: String
  let type: String
  let urlHTML: String

  let urlFollowers: String?
  let urlFollowing: String?
  let urlGists: String?
  let urlStarred: String?
  let urlSubscriptions: String?
  let urlOrganizations: String?
  let urlRepos: String?
  let urlEvents: String?
  let urlReceivedEvents: String?

  init?(json: JSON) {
    guard let id: Int = ("id" <~~ json),
      let login: String = ("login" <~~ json),
      let type: String = ("type" <~~ json),
      let urlHTML: String = ("html_url" <~~ json)
      else { return nil }

    self.id = id
    self.login = login
    self.type = type
    self.urlHTML = urlHTML

    self.urlFollowers = "followers_url" <~~ json
    self.urlFollowing = "following_url" <~~ json
    self.urlGists = "gists_url" <~~ json
    self.urlStarred = "starred_url" <~~ json
    self.urlSubscriptions = "subscriptions_url" <~~ json
    self.urlOrganizations = "organizations_url" <~~ json
    self.urlRepos = "repos_url" <~~ json
    self.urlEvents = "events_url" <~~ json
    self.urlReceivedEvents = "received_events_url" <~~ json
  }
}
