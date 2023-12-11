//
//  SearchViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private var originalUsersArray: [TwitterUser] = []
    private var filteredNamesArray: [String] = []
    private var usersNamesArray: [String] = []
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
    private func bindView(){
        viewModel.$users.sink { [weak self] users in
            self?.originalUsersArray = users ?? []
            self?.usersNamesArray = self?.originalUsersArray.map{$0.displayName} ?? []
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
        filteredNamesArray = usersNamesArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        searchTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = filteredNamesArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileViewController(id: "kOy3UkFJRyQEkaFES4YnnbYadk92")
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
