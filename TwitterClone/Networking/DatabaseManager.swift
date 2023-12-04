//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/11/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import FirebaseFirestore
import Combine

class DatabaseManager{
    static let shared = DatabaseManager()
    
    func setCollectionUsers(add user: User) -> AnyPublisher<Bool, Error>{
        let twitterUser = TwitterUser(from: user)
        return Firestore.firestore().collection(FCollectionPath.User.rawValue).document(twitterUser.id).setData(from: twitterUser)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    func getCollectionUser(retrevie id: String) -> AnyPublisher<TwitterUser, Error>{
        return Firestore.firestore().collection(FCollectionPath.User.rawValue).document(id).getDocument()
            .tryMap {
                try $0.data(as: TwitterUser.self)
            }
            .eraseToAnyPublisher()
    }
    func updateCollectionUser(updateFields: [String: Any], id: String) -> AnyPublisher<Bool, Error>{
        Firestore.firestore().collection(FCollectionPath.User.rawValue).document(id).updateData(updateFields)
            .map{ _ in true}
            .eraseToAnyPublisher()
    }
    func setCollectionTweets(add tweet: Tweet) -> AnyPublisher<Bool, Error>{
        return Firestore.firestore().collection(FCollectionPath.Tweet.rawValue).document(tweet.id).setData(from: tweet)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    func getCollectionTweets(retrevie id: String) -> AnyPublisher<[Tweet], Error>{
        return Firestore.firestore().collection(FCollectionPath.Tweet.rawValue).whereField("authorId", isEqualTo: id).getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map{
                    try $0.data(as: Tweet.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
}

enum FCollectionPath: String{
    case User
    case Tweet
}
