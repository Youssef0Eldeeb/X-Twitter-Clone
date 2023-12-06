//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {

    private lazy var viewModel : HomeViewModel = {
       return HomeViewModel()
    }()
    
    private var subscriptions: Set<AnyCancellable> = []
    // MARK: - UI Components
    private let timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    private lazy var tweetButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction{ [weak self] _ in
            let vc = UINavigationController(rootViewController: TweetViewController())
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        button.setImage(plusSign, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "blueTwitterColor")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        return button
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        view.addSubview(tweetButton)
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        configureNavigationBar()
        configureConstraints()
        bindViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retreiveUser()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    @objc func profileTap(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func settingTap(){
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    private func configureNavigationBar(){
        let size: CGFloat = 28
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "twitterLogo")
        
        let middelView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middelView.addSubview(logoImageView)
        navigationItem.titleView = middelView
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage, style: .plain, target: self, action: #selector(profileTap))
        
        let settingImage = UIImage(systemName: "gearshape")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(settingTap))
    }
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
    }
    private func bindViews(){
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            if !user.isUserOnboarded {
                self?.completeUserOnboarding()
            }
        }.store(in: &subscriptions)
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
            }
        }.store(in: &subscriptions)
    }
    private func completeUserOnboarding(){
        let vc = UINavigationController(rootViewController: EditProfileViewController())
        self.present(vc, animated: true)
    }
    private func configureConstraints(){
        let tweetButtonConstraints = [
            tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            tweetButton.widthAnchor.constraint(equalToConstant: 60),
            tweetButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(tweetButtonConstraints)
    }

}

// MARK: - +Delegate, DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier  , for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        let tweetModel = viewModel.tweets[indexPath.row]
        cell.configureTweet(displayName: tweetModel.author.displayName,
                            userName: tweetModel.author.userName,
                            tweetContent: tweetModel.tweetContent,
                            avatarPath: tweetModel.author.avatarPath)
        return cell
    }
  
}

extension HomeViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        print("reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("retweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("share")
    }
    
}
