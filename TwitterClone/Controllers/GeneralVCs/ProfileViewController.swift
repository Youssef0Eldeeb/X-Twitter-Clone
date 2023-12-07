//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 12/11/2023.
//

import UIKit
import Combine
import SDWebImage

protocol ProfileDelegate {
    func EditDidTap()
}

class ProfileViewController: UIViewController {

    private var isStatusBarHidden: Bool = true
    private var headerView: ProfileTableViewHeader!
    private var viewModel = ProfileViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableVeiw: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        profileTableVeiw.delegate = self
        profileTableVeiw.dataSource = self
        
        view.addSubview(profileTableVeiw)
        view.addSubview(statusBar)
        view.addSubview(backButton)
                
        headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableVeiw.frame.width, height: 370))
        profileTableVeiw.tableHeaderView = headerView
        profileTableVeiw.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        backButton.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
        configureConstraint()
        headerView.delegate = self
        bindView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileTableVeiw.frame = view.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retreiveUser()
    }
    @objc private func backBtnTap(){
        self.navigationController?.popViewController(animated: true)
    }
    private func configureConstraint(){
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        let backButtonConstraints = [
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(statusBarConstraints)
        NSLayoutConstraint.activate(backButtonConstraints)
    }
    private func bindView(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else {return}
            self?.headerView.nameLabel.text = user.displayName
            self?.headerView.usernameLabel.text = "@\(user.userName)"
            self?.headerView.bioLabel.text = user.bio
            self?.headerView.followersNumberLabel.text = "\(user.followersCount)"
            self?.headerView.followingNumberLabel.text = "\(user.followingCount)"
            self?.headerView.joinDateLabel.text = "Joined \(self?.viewModel.getFormattedDate(with: user.createdDate) ?? "")"
            self?.headerView.avatarProfileImageView.sd_setImage(with: URL(string: user.avatarPath), placeholderImage: UIImage(systemName: "person.circle.fill"))
        }.store(in: &subscriptions)
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileTableVeiw.reloadData()
            }
        }.store(in: &subscriptions)
    }
    

}

// MARK: - Extension + TableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.tweets.count <= 6 {
            return viewModel.tweets.count
        }else{
             return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        let tweetModel = viewModel.tweets[indexPath.row]
        cell.configureTweet(displayName: tweetModel.author.displayName,
                            userName: tweetModel.author.userName,
                            tweetContent: tweetModel.tweetContent,
                            avatarPath: tweetModel.author.avatarPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden{
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        }else if yPosition < 0 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
    
}

extension ProfileViewController: ProfileDelegate{
    
    func EditDidTap() {
        let vc = UINavigationController(rootViewController: EditProfileViewController())
        self.present(vc, animated: true)
    }
    
}
