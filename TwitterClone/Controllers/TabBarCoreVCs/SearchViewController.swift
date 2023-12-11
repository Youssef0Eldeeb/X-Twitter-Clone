//
//  SearchViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit
import Combine
import FirebaseAuth

class SearchViewController: UIViewController {
    
    private var originalArray: [TwitterUser] = []
    private var filteredArray: [TwitterUser] = []
    var selectedUser: TwitterUser?

    private var viewModel = SearchViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }()
    private let searchTableView = UITableView()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        viewModel.retreiveAllUser()
        bindView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    @objc func followUser(){
        print("followwwwwwwwwwwwww")
        guard let myId = Auth.auth().currentUser?.uid else { return }
        
        guard let selectedUser = selectedUser else {return}
        let newFollowersNumber = (selectedUser.followersCount) + 1
        let myData: [TwitterUser] = originalArray.filter{ $0.id == myId}
        let myNewFollowingNumber = myData[0].followingCount + 1
        print(myNewFollowingNumber)
        print(newFollowersNumber)
        viewModel.updateUserData(userId: selectedUser.id, followersCount: newFollowersNumber, followingCount: selectedUser.followingCount)
        viewModel.updateUserData(userId: myId, followersCount: myData[0].followersCount, followingCount: myNewFollowingNumber)
        
        
    }
    private func bindView(){
        viewModel.$users.sink { [weak self] users in
            self?.originalArray = users ?? []
        }.store(in: &subscriptions)
    }

}

// MARK: - + tableView and searchBar
extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search----")
        searchTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = originalArray.filter { $0.displayName.lowercased().contains(searchText.lowercased()) }
        searchTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = filteredArray[indexPath.row].displayName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let header = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: searchTableView.frame.width, height: 370))
        header.editButton.setTitle("Follow", for: .normal)
        header.editButton.backgroundColor = .label
        header.editButton.tintColor = .systemBackground
        header.editButton.addTarget(self, action: #selector(followUser), for: .touchUpInside)
        selectedUser = filteredArray[indexPath.row]
        let vc = ProfileViewController(id: selectedUser?.id ?? "", headerView: header)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
