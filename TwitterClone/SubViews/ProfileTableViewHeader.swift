//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 12/11/2023.
//

import UIKit

protocol ProfileFollowDelegateTap{
    func followersTap()
    func followingsTap()
}


class ProfileTableViewHeader: UIView {
    
    private enum SectionTabs: String{
        case posts = "Posts"
        case replies = "Replies"
        case highlights = "Highlights"
        case media  = "Media"
        case likes = "Likes"
        
        var index: Int {
            switch self{
            case .posts:
                return 0
            case .replies:
                return 1
            case .highlights:
                return 2
            case .media:
                return 3
            case .likes:
                return 4
            }
        }
        
    }
    
    private var selectedTab: Int = 0{
        didSet{
            for i in 0..<tabsButtons.count{
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                    self?.sectionStack.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                    self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                    self?.layoutIfNeeded()
                }
            }
        }
    }
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    var delegate: ProfileFollowDelegateTap!
    // MARK: - UI Components

    var coverProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        imageView.backgroundColor = UIColor(named: "blueTwitterColor")
        return imageView
    }()
    var avatarProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.backgroundColor = .darkGray
        imageView.tintColor = .white
        return imageView
    }()
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        button.tintColor = .label
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.8
        button.layer.borderColor = CGColor(gray: 0.28, alpha: 1)
        return button
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    var joinDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    var followingNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    var followersNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private let followingLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Following", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let followersLabel: UIButton = {
        let button = UIButton()
        button.setTitle("Follower", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(coverProfileImageView)
        self.addSubview(avatarProfileImageView)
        self.addSubview(editButton)
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
        self.addSubview(indicator)
        
        configureConstraints()
        configureStackButtonsPressed()
        
        self.followersLabel.addTarget(self, action: #selector(followersTap), for: .touchUpInside)
        self.followingLabel.addTarget(self, action: #selector(followingsTap), for: .touchUpInside)
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureStackButtonsPressed(){
        for (i, button) in sectionStack.arrangedSubviews.enumerated(){
            guard let button = button as? UIButton else{return}
            
            if i == selectedTab {
                button.tintColor = .label
            }else{
                button.tintColor = .secondaryLabel
            }
            
            button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        }
    }
    @objc private func didTap(_ sender: UIButton) {
        guard let label = sender.titleLabel?.text else {return}
        switch label{
        case SectionTabs.posts.rawValue:
            selectedTab = 0
        case SectionTabs.replies.rawValue:
            selectedTab = 1
        case SectionTabs.highlights.rawValue:
            selectedTab = 2
        case SectionTabs.media.rawValue:
            selectedTab = 3
        case SectionTabs.likes.rawValue:
            selectedTab = 4
        default:
            selectedTab = 0
        }
    }
    @objc func followersTap(){
        delegate.followersTap()
    }
    @objc func followingsTap(){
        delegate.followingsTap()
    }
    
    // MARK: - Constraints
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
        let editButtonConstraints = [
            editButton.topAnchor.constraint(equalTo: coverProfileImageView.bottomAnchor, constant: 10),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            editButton.widthAnchor.constraint(equalToConstant: 100),
            editButton.heightAnchor.constraint(equalToConstant: 30)
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
        
        for i in 0..<tabsButtons.count{
            let leadingAncher = indicator.leadingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].leadingAnchor)
            leadingAnchors.append(leadingAncher)
            let trailingAncher = indicator.trailingAnchor.constraint(equalTo: sectionStack.arrangedSubviews[i].trailingAnchor)
            trailingAnchors.append(trailingAncher)
        }
        let indicatorConstraints = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStack.arrangedSubviews[0].bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ]
        
        NSLayoutConstraint.activate(coverImageConstraints)
        NSLayoutConstraint.activate(avatarImageConstraints)
        NSLayoutConstraint.activate(editButtonConstraints)
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
        NSLayoutConstraint.activate(indicatorConstraints)
        
    }

}
