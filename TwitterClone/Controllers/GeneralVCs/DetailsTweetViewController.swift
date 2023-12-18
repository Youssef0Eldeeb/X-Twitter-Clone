//
//  DetailsTweetViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 17/12/2023.
//

import UIKit
import Combine

class DetailsTweetViewController: UIViewController {

    private let tableView = UITableView()
    var headerView = DetailsTweetViewHeader()
    var tweet: Tweet
    var myData: TwitterUser
    
    private var subscriptions: Set<AnyCancellable> = []
    
    
    init(tweet: Tweet, myData: TwitterUser){
        self.tweet = tweet
        self.myData = myData
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 360)
        headerView.configureTweet(tweet: tweet)
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        headerView.likesLabel.addTarget(self, action: #selector(showLikers), for: .touchUpInside)
        headerView.replyButton.addTarget(self, action: #selector(replyTap), for: .touchUpInside)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    
    @objc private func showLikers(){
        let vc = FollowViewController()
        vc.title = "Liked by"
        vc.followUsersId = tweet.likers
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func replyTap(){
        let detailsTweetViewModel = DetailsTweetViewModel()
        detailsTweetViewModel.tweetID = tweet.id
        let vc = UINavigationController(rootViewController: TweetViewController(user: myData, viewModel: detailsTweetViewModel))
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

}

// MARK: - + tableView
extension DetailsTweetViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier  , for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        
        return cell
    }
      
}

