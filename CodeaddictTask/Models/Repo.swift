//
//  Repo.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import Foundation

struct ReposResponse: Codable, Hashable {
    var items: [Repo]
}

struct Repo: Codable, Hashable {
    let id = UUID()
    
    private enum CodingKeys : String, CodingKey { case name, stargazersCount, commitsUrl, url, htmlUrl, owner }
    
    var name: String
    var stargazersCount: Int
    var commitsUrl: String
    var url: String
    var htmlUrl: String
    var owner: RepoAuthor
}
