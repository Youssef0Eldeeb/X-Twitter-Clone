//
//  SearchViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 10/12/2023.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject{
    var users: [TwitterUser]?
    @Published var error: String?
    @Published var usersNames: [String]?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUser(){
        DatabaseManager.shared.getCollectionAllUser()
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] users in
                self?.users = users
                self?.getNamesOfUsers()
            }.store(in: &subscriptions)
    }
    func getNamesOfUsers(){
        usersNames = users?.map({ user in
            user.displayName
        })
    }
    
}
