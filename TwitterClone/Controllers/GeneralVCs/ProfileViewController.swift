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
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        profileTableVeiw.delegate = self
        profileTableVeiw.dataSource = self
        
        view.addSubview(profileTableVeiw)
        view.addSubview(statusBar)
                
        headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableVeiw.frame.width, height: 370))
        profileTableVeiw.tableHeaderView = headerView
        profileTableVeiw.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        
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
    private func configureConstraint(){
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        NSLayoutConstraint.activate(statusBarConstraints)
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
            self?.headerView.avatarProfileImageView.sd_setImage(with: URL(string: user.avatarPath))
        }.store(in: &subscriptions)
    }
    

}

// MARK: - Extension + TableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        
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
