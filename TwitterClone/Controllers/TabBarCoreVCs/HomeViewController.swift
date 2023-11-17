//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    private let timelineTableView: UITableView = {
       let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(timelineTableView)
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        configureNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
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


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier  , for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        cell.delegate = self
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
