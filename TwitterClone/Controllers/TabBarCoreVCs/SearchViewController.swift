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
    let myId = Auth.auth().currentUser?.uid
    var header: ProfileTableViewHeader?

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
        
        bindView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        viewModel.retreiveAllUser()
    }
    @objc func editDidTap() {
        let vc = UINavigationController(rootViewController: EditProfileViewController())
        self.present(vc, animated: true)
    }
    @objc func followUser(){
        UIView.animate(withDuration: 0.3) {
            self.header?.editButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.header?.editButton.transform = CGAffineTransform.identity
            }
        }
        guard let myId = self.myId else { return }
        guard let selectedUser = selectedUser else {return}
        
        let myData: [TwitterUser] = originalArray.filter{ $0.id == myId}
        
        viewModel.updateUserData(selectedUser: selectedUser, myData: myData[0])
        
        self.header?.editButton.setTitle("Following", for: .normal)
        self.header?.editButton.backgroundColor = .systemBackground
        self.header?.editButton.tintColor = .label
        
        
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
        header = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: searchTableView.frame.width, height: 370))
        selectedUser = filteredArray[indexPath.row]
        if (selectedUser?.id == myId) {
            header?.editButton.addTarget(self, action: #selector(editDidTap), for: .touchUpInside)
        }else{
            header?.editButton.setTitle("Follow", for: .normal)
            header?.editButton.backgroundColor = .label
            header?.editButton.tintColor = .systemBackground
            header?.editButton.addTarget(self, action: #selector(followUser), for: .touchUpInside)
        }
        
        let vc = ProfileViewController(id: selectedUser?.id ?? "", headerView: header ?? ProfileTableViewHeader())
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
