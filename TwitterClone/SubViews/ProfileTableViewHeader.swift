//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 12/11/2023.
//

import UIKit

class ProfileTableViewHeader: UIView {

    // UI Components
    private let coverProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "coverProfile")
        return imageView
    }()
    private let avatarProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.image = UIImage(named: "coverProfile")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Youssef Eldeeb"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@youssef3109"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "لا حول ولا قوة الا بالله العلي العظيم"
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "calendar",withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    private let joinDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Joined October 2023"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private let followingNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "52"
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private let followersNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "13"
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Followers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private var tabsButtons: [UIButton] = ["Posts", "Replies", "Highlights", "Media", "Likes"]
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.tintColor = .label
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    private lazy var sectionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabsButtons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(coverProfileImageView)
        self.addSubview(avatarProfileImageView)
        self.addSubview(nameLabel)
        self.addSubview(usernameLabel)
        self.addSubview(bioLabel)
        self.addSubview(joinDateImageView)
        self.addSubview(joinDateLabel)
        self.addSubview(followingNumberLabel)
        self.addSubview(followingLabel)
        self.addSubview(followersNumberLabel)
        self.addSubview(followersLabel)
        self.addSubview(sectionStack)
        
        configureConstraints()
        configureStackButtonsPressed()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureStackButtonsPressed(){
        for (_, button) in sectionStack.arrangedSubviews.enumerated(){
            guard let button = button as? UIButton else{return}
            button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        }
    }
    @objc private func didTap(_ sender: UIButton) {
        print(sender.titleLabel?.text ?? "")
    }
    
    private func configureConstraints(){
        let coverImageConstraints = [
            coverProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            coverProfileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            coverProfileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            coverProfileImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        let avatarImageConstraints = [
            avatarProfileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            avatarProfileImageView.centerYAnchor.constraint(equalTo: coverProfileImageView.bottomAnchor, constant: 10),
            avatarProfileImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarProfileImageView.heightAnchor.constraint(equalToConstant: 70)
        ]
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: avatarProfileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarProfileImageView.bottomAnchor, constant: 10)
        ]
        let usernameConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: avatarProfileImageView.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3)
        ]
        let bioConstraints = [
            bioLabel.leadingAnchor.constraint(equalTo: avatarProfileImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15)
        ]
        let joinDateImageViewConstraints = [
            joinDateImageView.leadingAnchor.constraint(equalTo: avatarProfileImageView.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 8)
        ]
        let joinDateLabelConstraints = [
            joinDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 2),
            joinDateLabel.centerYAnchor.constraint(equalTo: joinDateImageView.centerYAnchor)
        ]
        let followingNumberLabelConstraints = [
            followingNumberLabel.leadingAnchor.constraint(equalTo: avatarProfileImageView.leadingAnchor),
            followingNumberLabel.topAnchor.constraint(equalTo: joinDateImageView.bottomAnchor, constant: 12)
        ]
        let followingLabelConstraints = [
            followingLabel.leadingAnchor.constraint(equalTo: followingNumberLabel.trailingAnchor, constant: 1),
            followingLabel.centerYAnchor.constraint(equalTo: followingNumberLabel.centerYAnchor)
        ]
        let followersNumberLabelConstraints = [
            followersNumberLabel.leadingAnchor.constraint(equalTo: followingLabel.trailingAnchor, constant: 10),
            followersNumberLabel.centerYAnchor.constraint(equalTo: followingNumberLabel.centerYAnchor)
        ]
        let followersLabelConstraints = [
            followersLabel.leadingAnchor.constraint(equalTo: followersNumberLabel.trailingAnchor, constant: 1),
            followersLabel.centerYAnchor.constraint(equalTo: followingNumberLabel.centerYAnchor)
        ]
        let sectionStackConstraints = [
            sectionStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            sectionStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            sectionStack.topAnchor.constraint(equalTo: followingNumberLabel.bottomAnchor, constant: 10),
            sectionStack.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        
        NSLayoutConstraint.activate(coverImageConstraints)
        NSLayoutConstraint.activate(avatarImageConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(usernameConstraints)
        NSLayoutConstraint.activate(bioConstraints)
        NSLayoutConstraint.activate(joinDateImageViewConstraints)
        NSLayoutConstraint.activate(joinDateLabelConstraints)
        NSLayoutConstraint.activate(followingNumberLabelConstraints)
        NSLayoutConstraint.activate(followingLabelConstraints)
        NSLayoutConstraint.activate(followersNumberLabelConstraints)
        NSLayoutConstraint.activate(followersLabelConstraints)
        NSLayoutConstraint.activate(sectionStackConstraints)
        
    }

}
