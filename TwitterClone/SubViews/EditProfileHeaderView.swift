//
//  EditProfileHeaderView.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 26/11/2023.
//

import UIKit

class EditProfileHeaderView: UIView {

    var delegate: EditProfileDelegate!
    
    // MARK: - UI Components
    var coverProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .darkGray
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    var avatarProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.backgroundColor = .systemPurple
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(coverProfileImageView)
        self.addSubview(avatarProfileImageView)
        configureConstraints()
        
        
        coverProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverImageTap)))
        avatarProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarImageTap)))
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    @objc private func coverImageTap(){
        delegate?.coverImageDidTap()
    }
    @objc func avatarImageTap(){
        delegate?.avatarImageDidTap()
    }
    
    private func configureConstraints(){
        let coverImageConstraints = [
            coverProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverProfileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverProfileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            coverProfileImageView.heightAnchor.constraint(equalToConstant: 140)
        ]
        let avatarImageConstraints = [
            avatarProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            avatarProfileImageView.centerYAnchor.constraint(equalTo: coverProfileImageView.bottomAnchor, constant: 10),
            avatarProfileImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarProfileImageView.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(coverImageConstraints)
        NSLayoutConstraint.activate(avatarImageConstraints)
    }
}
