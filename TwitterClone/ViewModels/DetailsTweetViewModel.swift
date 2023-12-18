//
//  DetailsTweetViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/12/2023.
//

import Foundation
import Combine
import FirebaseAuth

class DetailsTweetViewModel: TweetViewModel {
    
    var tweetID: String = ""
    
    override func addTweet(){
        guard let user = user else {return}
        let comment = Comment(tweetId: tweetID, authorId: user.id, author: user, commentContent: tweetContent)
        DatabaseManager.shared.setCollectionComment(add: comment)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.isTweeted = state
            }.store(in: &subscriptions)
    }
    
    
    
}
