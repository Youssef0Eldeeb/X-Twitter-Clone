//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 26/11/2023.
//

import Foundation


class EditProfileViewModel: ObservableObject{
    
    @Published var name: String?
    @Published var username: String?
    @Published var bio: String?
    @Published var avatarPath: String?
    
}
