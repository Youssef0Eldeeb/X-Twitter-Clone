//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 28/11/2023.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewModel: ObservableObject{
    @Published var user: TwitterUser?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func retreiveUser(){
        guard let id = Auth.auth().currentUser?.uid else { return }
        DatabaseManager.shared.getCollectionUser(retrevie: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }.store(in: &subscriptions)

    }
    func getFormattedDate(with date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: date)
    }
}
