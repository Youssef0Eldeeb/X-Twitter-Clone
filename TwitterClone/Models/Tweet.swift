//
//  Tweet.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 04/12/2023.
//

import Foundation

struct Tweet: Codable{
    var id = UUID().uuidString
    let author: TwitterUser
    let authorId: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
