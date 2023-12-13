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
    func updateUserData(selectedUser: TwitterUser, myData: TwitterUser){
        var selectedUser = selectedUser
        var myData = myData
        
        let userFollowersNumber = (selectedUser.followersCount) + 1
        selectedUser.followers.append(myData.id)
        let myFollowingNumber = (myData.followingCount) + 1
        myData.followings.append(selectedUser.id)
        
        let updatedSelectedUserFields: [String: Any] = [
            "followersCount": userFollowersNumber,
            "followingCount": selectedUser.followingCount,
            "followers": selectedUser.followers,
            "followings": selectedUser.followings
        ]
        let updatedMyDataFields: [String: Any] = [
            "followersCount": myData.followersCount,
            "followingCount": myFollowingNumber,
            "followers": myData.followers,
            "followings": myData.followings
        ]
        DatabaseManager.shared.updateCollectionUser(updateFields: updatedSelectedUserFields, id: selectedUser.id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("error:\n" + error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { _ in
            }).store(in: &subscriptions)
        DatabaseManager.shared.updateCollectionUser(updateFields: updatedMyDataFields, id: myData.id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("error:\n" + error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { _ in
            }).store(in: &subscriptions)

    }
    
}
