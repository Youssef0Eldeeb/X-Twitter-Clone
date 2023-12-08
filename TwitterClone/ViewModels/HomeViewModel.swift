//
//  HomeViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/11/2023.
//

import Foundation
import Combine
import FirebaseAuth

class HomeViewModel: ObservableObject{
    
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var tweetId: String?
    var likesCount: Int = 0
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.getCollectionUser(retrevie: id)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
                self?.fetchTweets()
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &subscriptions)

    }
    
    func fetchTweets(){
        DatabaseManager.shared.getCollectionAllTweets()
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] receivedTweets in
                self?.tweets = receivedTweets
            }.store(in: &subscriptions)

    }
    func updateLikesCount(){
        guard let id = tweetId else { return }
        let updatedFields: [String: Any] = [
            "likesCount": likesCount + 1
        ]
        DatabaseManager.shared.updateCollectionTweet(updateFields: updatedFields, id: id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("error:\n" + error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] updated in
                print(updated)
            }).store(in: &subscriptions)
    }
    
    
}
