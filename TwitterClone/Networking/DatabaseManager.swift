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
    func getCollectionAllUser() -> AnyPublisher<[TwitterUser], Error>{
        return Firestore.firestore().collection(FCollectionPath.User.rawValue).getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map{
                    try $0.data(as: TwitterUser.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func updateCollectionUser(updateFields: [String: Any], id: String) -> AnyPublisher<Bool, Error>{
       return
        Firestore.firestore().collection(FCollectionPath.User.rawValue).document(id).updateData(updateFields)
            .map{ _ in true}
            .eraseToAnyPublisher()
    }
    
    func updateCollectionTweet(updateFields: [String: Any], id: String) -> AnyPublisher<Bool, Error>{
       return
        Firestore.firestore().collection(FCollectionPath.Tweet.rawValue).document(id).updateData(updateFields)
            .map{ _ in true}
            .eraseToAnyPublisher()
    }
    
    func updateCollectionSpecificTweets(updateFields: [String: Any], id: String) -> AnyPublisher<Bool, Error>{
       return
        Firestore.firestore().collection(FCollectionPath.Tweet.rawValue).whereField("authorId", isEqualTo: id).getDocuments()
            .tryMap({ snapshot in
                snapshot.documents.map({ documentSnapshot in
                    documentSnapshot.reference.updateData(updateFields)
                })
            })
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
    
    func getCollectionAllTweets() -> AnyPublisher<[Tweet], Error>{
        return Firestore.firestore().collection(FCollectionPath.Tweet.rawValue).getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map{
                    try $0.data(as: Tweet.self)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getCollectionSpecificTweet(tweetId: String) -> AnyPublisher<Tweet, Error>{
        return Firestore.firestore().collection(FCollectionPath.Tweet.rawValue).document(tweetId).getDocument()
            .tryMap {
                try $0.data(as: Tweet.self)
            }
            .eraseToAnyPublisher()
    }
    
    func setCollectionComment(add comment: Comment) -> AnyPublisher<Bool, Error>{
        return Firestore.firestore().collection(FCollectionPath.Comment.rawValue).document(comment.id).setData(from: comment)
            .map { _ in
                return true
            }
            .eraseToAnyPublisher()
    }
}

enum FCollectionPath: String{
    case User
    case Tweet
    case Comment
}
