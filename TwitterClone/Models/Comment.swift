//
//  Comment.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/12/2023.
//

import Foundation

struct Comment: Codable{
    var id = UUID().uuidString
    let tweetId: String
    let authorId: String
    let author: TwitterUser
    let commentContent: String
}
