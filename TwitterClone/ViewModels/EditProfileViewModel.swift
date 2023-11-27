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


class EditProfileViewModel: ObservableObject{
    
    @Published var avatarPath: String?
    @Published var coverPath: String?
    @Published var name: String?
    @Published var bio: String?
    @Published var location: String?
    @Published var website: String?
    @Published var birthDate: String?
    @Published var avatarImageData: UIImage?
    @Published var coverImageData: UIImage?
    @Published var isFormValid: Bool = false
    @Published var error: String = ""
    @Published var url: URL?
    
    var subscriptions: Set<AnyCancellable> = []
    
    
    func validateUserProfile(){
        guard let name = name, name.count > 2 else{
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
            if case .failure(let error) = completion{
                self?.error = error.localizedDescription
            }
        } receiveValue: { [weak self] url in
            self?.url = url
        }.store(in: &subscriptions)

    }
    
}
