//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 15/11/2023.
//

import Foundation
import Firebase
import Combine

class AuthenticationViewModel: ObservableObject{
    
    @Published var email: String?
    @Published var password: String?
    @Published var isAuthenticationValid: Bool = false
    @Published var user: User?
    @Published var error: String?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateAuthentication(){
        guard let email = email, let password = password else{
            isAuthenticationValid = false
            return
        }
        isAuthenticationValid = isValidEmail(email) && password.count >= 8
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser(){
        guard let email = email, let password = password else{ return }
        AuthenticationManager.shared.registerUser(email: email, password: password)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.user = user
            })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.createRecord(for: user)
            }
            .store(in: &subscriptions)
    }
    private func createRecord(for user: User){
        DatabaseManager.shared.setCollectionUsers(add: user)
            .sink { [weak self] completion in
                if case .failure(let error) = completion{
                    self?.error = error.localizedDescription
                }
            } receiveValue: { state in
                print("adding user record to database : \(state)")
            }
            .store(in: &subscriptions)

    }
    
    func loginUser(){
        guard let email = email, let password = password else{ return }
        AuthenticationManager.shared.loginUser(email: email, password: password)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)
    }
    
}
