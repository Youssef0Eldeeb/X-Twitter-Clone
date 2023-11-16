//
//  RegisterViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 15/11/2023.
//

import Foundation
import Firebase
import Combine

class RegisterViewModel: ObservableObject{
    
    @Published var email: String?
    @Published var password: String?
    @Published var isRegistrationValid: Bool = false
    @Published var user: User?
    
    private var subscriptions: Set<AnyCancellable> = []
    
    func validateRegistration(){
        guard let email = email, let password = password else{
            isRegistrationValid = false
            return
        }
        isRegistrationValid = isValidEmail(email) && password.count >= 8
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createUser(){
        guard let email = email, let password = password else{ return }
        AuthenticationManager.shared.registerUser(email: email, password: password)
            .sink { _ in
                
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &subscriptions)

    }

    
}
