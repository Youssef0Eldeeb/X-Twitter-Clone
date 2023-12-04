//
//  TweetTableViewCell.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit

protocol TweetTableViewCellDelegate: AnyObject{
    func tweetTableViewCellDidTapReply()
    func tweetTableViewCellDidTapRetweet()
    func tweetTableViewCellDidTapLike()
    func tweetTableViewCellDidTapShare()
}



class TweetTableViewCell: UITableViewCell {

    static let identifier = String(describing: TweetTableViewCell.self)
    
    weak var delegate: TweetTableViewCellDelegate?
    
    private let actionSpacing: CGFloat = 55
    
    // MARK: - UI Components
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .blue
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let textContentlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(textContentlabel)
        contentView.addSubview(replyButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(shareButton)
        configureConstraints()
        configureButtonsTaps()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    @objc func replyTaped(){
        delegate?.tweetTableViewCellDidTapReply()
    }
    @objc func retweetTaped(){
        delegate?.tweetTableViewCellDidTapRetweet()
    }
    @objc func likeTapped(){
        delegate?.tweetTableViewCellDidTapLike()
    }
    @objc func shareTapped(){
        delegate?.tweetTableViewCellDidTapShare()
    }
    
    private func configureButtonsTaps(){
        replyButton.addTarget(self, action: #selector(replyTaped), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(retweetTaped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    func configureTweet(displayName: String, userName: String, tweetContent: String, avatarPath: String){
        nameLabel.text = displayName
        userNameLabel.text = "@\(userName)"
        textContentlabel.text = tweetContent
        avatarImageView.sd_setImage(with: URL(string: avatarPath))
    }
    
    private func configureConstraints(){
        let avaterImageViewConstaints = [
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ]
        let textContentLabelConstraints = [
            textContentlabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            textContentlabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            textContentlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30)
        ]
        let replyButtonConstraints = [
            replyButton.leadingAnchor.constraint(equalTo: textContentlabel.leadingAnchor),
            replyButton.topAnchor.constraint(equalTo: textContentlabel.bottomAnchor, constant: 10),
            replyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        let retweetButtonConstraints = [
            retweetButton.leadingAnchor.constraint(equalTo: replyButton.trailingAnchor, constant: actionSpacing),
            retweetButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: actionSpacing),
            likeButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        let shareButtonConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: actionSpacing),
            shareButton.centerYAnchor.constraint(equalTo: replyButton.centerYAnchor)
        ]
        
        
        
        NSLayoutConstraint.activate(avaterImageViewConstaints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(textContentLabelConstraints)
        NSLayoutConstraint.activate(replyButtonConstraints)
        NSLayoutConstraint.activate(retweetButtonConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
        
    }
    
    
}
