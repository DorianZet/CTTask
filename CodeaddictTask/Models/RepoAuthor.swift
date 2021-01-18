//
//  RepoAuthor.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import Foundation

struct RepoAuthor: Codable, Hashable {
    var login: String
    var id: Int
    var avatarUrl: String
}
