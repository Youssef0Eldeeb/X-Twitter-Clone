//
//  ProfileDataFormViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/11/2023.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        tableView.allowsSelection = false
        return tableView
    }()
       
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        configureConstraints()
        congigureNavigationBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @objc private func cancelBtnTap(){
        self.dismiss(animated: true)
    }
    
    private func congigureNavigationBar(){
        self.navigationItem.title = "Edit profile"
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelBtnTap))
        leftBarButton.tintColor = .label
        navigationItem.leftBarButtonItem = leftBarButton
    }
    private func configureConstraints(){
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)  
    }

}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifier, for: indexPath) as? EditProfileTableViewCell else {
            return UITableViewCell()
        }
//         Configure the cell based on the indexPath
        switch indexPath.row {
        case 0:
            cell.title.text = "Name"
            cell.textField.placeholder = "Add your name"
        case 1:
            cell.title.text = "Bio"
            cell.textField.placeholder = "Add your bio"
        case 2:
            cell.title.text = "Location"
            cell.textField.placeholder = "Add your location"
        case 3:
            cell.title.text = "Website"
            cell.textField.placeholder = "Add your website"
        case 4:
            cell.title.text = "Birth date"
            cell.textField.placeholder = "Add your birth date"
        default:
            break
        }
        return cell
    }
}


