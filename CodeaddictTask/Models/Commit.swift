//
//  Commit.swift
//  CodeaddictTask
//
//  Created by Mateusz Zacharski on 14/01/2021.
//

import Foundation

struct CommitInfo: Codable, Hashable {
    var committer: CommitAuthor
    var message: String
}

struct Commit: Codable, Hashable {
    var commit: CommitInfo
}
