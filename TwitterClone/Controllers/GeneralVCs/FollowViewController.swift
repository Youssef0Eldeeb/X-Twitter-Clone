//
//  FollowViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 14/12/2023.
//

import UIKit

class FollowViewController: UIViewController {

    private let followTableView = UITableView()
    var followUsers: [TwitterUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(followTableView)
        
        followTableView.delegate = self
        followTableView.dataSource = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        followTableView.frame = view.frame
    }
    


}

// MARK: - + tableView
extension FollowViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = followUsers[indexPath.row].displayName
        return cell
    }
    
    
}
