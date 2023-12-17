//
//  FollowViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 14/12/2023.
//

import UIKit
import Combine

class FollowViewController: UIViewController {

    private let followTableView = UITableView()
    var followUsersId: [String] = []
    var usersArray: [TwitterUser] = []
    var viewModel = FollowViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.addSubview(followTableView)
        
        followTableView.delegate = self
        followTableView.dataSource = self
        
        viewModel.usersId = followUsersId
        viewModel.retreiveUsers()
        bindViews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        followTableView.frame = view.frame
    }
    private func bindViews(){
        viewModel.$users.sink { [weak self] users in
            self?.usersArray = users
            self?.followTableView.reloadData()
        }.store(in: &subscriptions)
        viewModel.$error.sink { [weak self] error in
            guard let error = error else {return}
            UIAlertController.showAlert(msg: error, form: self!)
        }.store(in: &subscriptions)
    }


}

// MARK: - + tableView
extension FollowViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = usersArray[indexPath.row].displayName
        return cell
    }
      
}
