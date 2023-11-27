//
//  StorageManager.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 27/11/2023.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum StorageError: Error{
    case invalidImageID
}

final class StorageManager{
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    func uploadPhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .eraseToAnyPublisher()
    }
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error>{
        guard let id = id else {
            return Fail(error: StorageError.invalidImageID)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .eraseToAnyPublisher()
    }
}
