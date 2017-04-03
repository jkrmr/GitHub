//
//  Repository.swift
//  GitHub
//
//  Created by Jake Romer on 4/2/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import Gloss

struct Repository: Decodable {
  let id: Int
  let name: String
  let fullName: String
  let owner: User
  let url: String
  let urlHTML: String
  let createdAt: String
  let isPrivate: Bool
  let isFork: Bool
  
  let description: String
  let homepage: String
  let language: String
  let topics: [String]
  let forksCount: Int
  let stargazersCount: Int
  let subscribersCount: Int
  let watchersCount: Int
  
  init?(json: JSON) {
    guard let id: Int = "id" <~~ json,
      let name: String = "name" <~~ json,
      let fullName: String = "full_name" <~~ json,
      let owner: User = "owner" <~~ json,
      let url: String = "url" <~~ json,
      let urlHTML: String = "html_url" <~~ json,
      let createdAt: String = "created_at" <~~ json,
      let isPrivate: Bool = "private" <~~ json,
      let isFork: Bool = "fork" <~~ json
      else { return nil }

    self.id = id
    self.name = name
    self.fullName = fullName
    self.owner = owner
    self.url = url
    self.urlHTML = urlHTML
    self.createdAt = createdAt
    self.isPrivate = isPrivate
    self.isFork = isFork
    self.description = "description" <~~ json ?? ""
    self.homepage = "homepage" <~~ json ?? ""
    self.language = "language" <~~ json ?? ""
    self.topics = "topics" <~~ json ?? []
    self.forksCount = "forks_count" <~~ json ?? 0
    self.stargazersCount = "stargazers_count" <~~ json ?? 0
    self.subscribersCount = "subscribers_count" <~~ json ?? 0
    self.watchersCount = "watchers_count" <~~ json  ?? 0
  }
}


// has_downloads
// has_issues
// has_pages
// has_projects
// has_wiki

// archive_url
// assignees_url
// blobs_url
// branches_url
// clone_url
// collaborators_url
// comments_url
// commits_url
// compare_url
// contents_url
// contributors_url
// deployments_url
// downloads_url
// events_url
// forks_url
// git_commits_url
// git_refs_url
// git_tags_url
// git_url
// hooks_url
// html_url
// issue_comment_url
// issue_events_url
// issues_url
// keys_url
// labels_url
// language
// languages_url
// merges_url
// milestones_url
// mirror_url
// notifications_url
// open_issues
// open_issues_count
// pulls_url
// pushed_at
// releases_url
// ssh_url
// stargazers_url
// statuses_url
// subscribers_url
// subscription_url
// svn_url
// tags_url
// teams_url
// trees_url
// updated_at
