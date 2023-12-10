//
//  SearchViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private var originalArray: [String] = []
    private var filteredArray: [String] = []
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
        
        viewModel.retreiveUser()
        bindView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.frame
    }
    private func bindView(){
        viewModel.$usersNames.sink { [weak self] usersNames in
            self?.originalArray = usersNames ?? []
            self?.filteredArray = self?.originalArray ?? []
        }.store(in: &subscriptions)
    }

}

// MARK: - + tableView and searchBar
extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search----")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = originalArray.filter { $0.lowercased().contains(searchText.lowercased()) }
        searchTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = filteredArray[indexPath.row]
        return cell
    }
    
    
}
