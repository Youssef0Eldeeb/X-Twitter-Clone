//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 26/11/2023.
//

import Foundation
import UIKit
import FirebaseStorage
import Combine
import FirebaseAuth

class EditProfileViewModel: ObservableObject{
    
    @Published var avatarPath: String?
    @Published var coverPath: String?
    @Published var name: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var location: String?
    @Published var website: String?
    @Published var birthDate: String?
    @Published var avatarImageData: UIImage?
    @Published var coverImageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String = ""
    @Published var isOnboarding: Bool = false
    
    var subscriptions: Set<AnyCancellable> = []
    
    
    func validateUserProfile(){
        guard let name = name, name.count > 2,
              let username = username, username.count > 2,
              avatarImageData != nil
        else{
            isFormValid = false
            return
        }
        isFormValid = true
              
    }
    
    func uploadAvatar(){
        let randomId = UUID().uuidString
        guard let imageData = avatarImageData?.jpegData(compressionQuality: 0.5) else{return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        StorageManager.shared.uploadPhoto(with: randomId, image: imageData, metaData: metaData)
            .flatMap({ metaData in
                StorageManager.shared.getDownloadURL(for: metaData.path)
            })
            .sink { [weak self] completion in
                switch completion{
                case .finished:
                    self?.updateUserData()
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
        } receiveValue: { [weak self] url in
            self?.avatarPath = url.absoluteString
        }.store(in: &subscriptions)

    }
    private func updateUserData(){
        guard let name = name,
              let username = username,
              let avatarPath = avatarPath,
              let id = Auth.auth().currentUser?.uid
        else { return }
        let updatedFields: [String: Any] = [
            "displayName": name,
            "userName" : username,
            "bio": bio ?? "",
            "avatarPath": avatarPath,
            "isUserOnboarded": true
        ]
        DatabaseManager.shared.updateCollectionUser(updateFields: updatedFields, id: id)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("error:\n" + error.localizedDescription)
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] updated in
                self?.isOnboarding = updated
            }).store(in: &subscriptions)

    }
    
}
