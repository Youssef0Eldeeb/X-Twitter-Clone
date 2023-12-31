//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit
import FirebaseAuth
import Combine
import SDWebImage

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
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(addTweetTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        button.setImage(plusSign, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "blueTwitterColor")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        return button
    }()
    

    private func profileBarButton(avatarPath: String) -> UIBarButtonItem {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 15
        
        let button = UIButton(frame: customView.bounds)
        button.addTarget(self, action: #selector(profileTap), for: .touchUpInside)
        button.sd_setImage(with: URL(string: avatarPath), for: .normal, placeholderImage: UIImage(systemName: "person"))
        customView.addSubview(button)
        
        let customBarButtonItem = UIBarButtonItem(customView: customView)
        return customBarButtonItem
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        view.addSubview(tweetButton)
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.center.x, y: view.center.y)
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        timelineTableView.refreshControl = refreshControl
        
        configureNavigationBar()
        configureConstraints()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        activityIndicator.startAnimating()
        handleAuthentication()
        viewModel.retreiveUser()
        bindViews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timelineTableView.frame = view.frame
    }
    
    @objc private func profileTap(){
        let vc = ProfileViewController(user: viewModel.user ?? TwitterUser(from: Auth.auth().currentUser!))
        vc.headerView.editButton.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func editDidTap() {
        let vc = UINavigationController(rootViewController: EditProfileViewController(user: viewModel.user ?? TwitterUser(from: Auth.auth().currentUser!)))
        self.present(vc, animated: true)
    }
    @objc func settingTap(){
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func refreshData() {
        viewModel.retreiveUser()
        bindViews()
    }
    @objc func addTweetTap(){
        let vc = UINavigationController(rootViewController: TweetViewController(user: viewModel.user!, viewModel: TweetViewModel()))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func configureNavigationBar(){
        let size: CGFloat = 28
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "twitterLogo")
        
        let middelView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middelView.addSubview(logoImageView)
        navigationItem.titleView = middelView
        
        let settingImage = UIImage(systemName: "gearshape")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: settingImage, style: .plain, target: self, action: #selector(settingTap))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(profileTap))
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
            self?.navigationItem.leftBarButtonItem = self?.profileBarButton(avatarPath: user.avatarPath)
        }.store(in: &subscriptions)
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timelineTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }.store(in: &subscriptions)
        viewModel.$error.sink { [weak self] error in
            guard let error = error else {return}
            UIAlertController.showAlert(msg: error, form: self!)
        }.store(in: &subscriptions)
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    private func completeUserOnboarding(){
        let vc = UINavigationController(rootViewController: EditProfileViewController(user:  TwitterUser(from: Auth.auth().currentUser!)))
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
        cell.likeButton.tag = indexPath.row
        if viewModel.likesTweetIds.contains(tweetModel.id){
//            print("change likes in this tweet: \(indexPath.row) and its id is: \(tweetModel.id)")
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.tintColor = .red
        }else{
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.likeButton.tintColor = .systemGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsTweetViewController(tweet: viewModel.tweets[indexPath.row], myData: viewModel.user!)
        navigationController?.pushViewController(vc, animated: true)
    }
  
}

extension HomeViewController: TweetTableViewCellDelegate{
    func tweetTableViewCellDidTapReply() {
        print("reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("retweet")
    }
    
    func tweetTableViewCellDidTapLike(tag: Int) {
        viewModel.tweetId = viewModel.tweets[tag].id
        viewModel.getSpecificTweet()
    }
    
    func tweetTableViewCellDidTapShare() {
        print("share")
    }
    
}
