//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 04/12/2023.
//

import Foundation
import Combine
import FirebaseAuth

final class TweetViewModel: ObservableObject {
     
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published var isValidToTweet: Bool = false
    @Published var error: String = ""
    @Published var isTweeted: Bool = false
    var tweetContent: String = ""
    private var user: TwitterUser?
    
    func getUserData(){
        guard let userId = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.getCollectionUser(retrevie: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] twitterUser in
                self?.user = twitterUser
            }.store(in: &subscriptions)

    }
    
    func validateToTweet(){
        isValidToTweet = !tweetContent.isEmpty
    }
    
    func addTweet(){
        guard let user = user else {return}
        let tweet = Tweet(author: user, authorId: user.id, tweetContent: tweetContent, likesCount: 0, likers: [], isReply: false, parentReference: nil)
        DatabaseManager.shared.setCollectionTweets(add: tweet)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] state in
                self?.isTweeted = state
            }.store(in: &subscriptions)
    }
    
    
}
