//
//  ProfileDataFormViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/11/2023.
//

import Foundation


class ProfileDataFormViewModel: ObservableObject{
    
    @Published var name: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
}
