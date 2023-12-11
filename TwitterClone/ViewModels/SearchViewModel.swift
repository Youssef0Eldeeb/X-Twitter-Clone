//
//  SearchViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 10/12/2023.
//

import Foundation
import Combine
import FirebaseAuth

final class SearchViewModel: ObservableObject{
    @Published var users: [TwitterUser]?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveAllUser(){
        DatabaseManager.shared.getCollectionAllUser()
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }.store(in: &subscriptions)
    }
    func updateUserData(userId: String, followersCount: Int, followingCount: Int){
        let updatedFields: [String: Any] = [
            "followersCount": followersCount,
            "followingCount": followingCount
        ]
        DatabaseManager.shared.updateCollectionUser(updateFields: updatedFields, id: userId)
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
