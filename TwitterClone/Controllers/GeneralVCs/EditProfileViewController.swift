//
//  ProfileDataFormViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/11/2023.
//

import UIKit
import PhotosUI

protocol EditProfileDelegate{
    func coverImageDidTap()
    func avatarImageDidTap()
}

class EditProfileViewController: UIViewController {
    
    var headerView: EditProfileHeaderView!
    var imageTap: EditProfileImagesTap?
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
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
        
        headerView = EditProfileHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 210))
        tableView.tableHeaderView = headerView
//        tableView.contentInsetAdjustmentBehavior = .never
        headerView.delegate = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss)))
    }
    
    @objc private func cancelBtnTap(){
        self.dismiss(animated: true)
    }
    @objc private func tapToDismiss(){
        view.endEditing(true)
    }
    
    private func congigureNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationItem.title = "Edit profile"
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelBtnTap))
        leftBarButton.tintColor = .label
        navigationItem.leftBarButtonItem = leftBarButton
    }
    private func configureConstraints(){
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)  
    }

}
// MARK: - TableView Extension
extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
            cell.textField.placeholder = "Add a Bio to your profile"
        case 2:
            cell.title.text = "Location"
            cell.textField.placeholder = "Add your location"
            cell.accessoryType = .disclosureIndicator
//            cell.textField.isEnabled = false
        case 3:
            cell.title.text = "Website"
            cell.textField.placeholder = "Add your website"
            cell.accessoryType = .disclosureIndicator
        case 4:
            cell.title.text = "Birth date"
            cell.textField.placeholder = "Add your birth date"
        case 5:
            cell.textLabel?.text = "Switch to Professional"
            cell.title.isHidden = true
            cell.textField.isHidden = true
            cell.accessoryType = .disclosureIndicator
        case 6:
            cell.title.isHidden = true
            cell.textField.isHidden = true
        case 7:
            cell.title.text = "Tips"
            cell.textField.isHidden = true
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 1:
            return 80
        case 6:
            return 30
        default:
            return 40
        }
    }
}


extension EditProfileViewController: EditProfileDelegate, PHPickerViewControllerDelegate{
    
    func coverImageDidTap() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        imageTap = .coverImageTap
        present(picker, animated: true)
    }
    
    func avatarImageDidTap() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        imageTap = .avatarImageTap
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results{
            result.itemProvider.loadObject(ofClass: UIImage.self) {[weak self] object, error in
                if let image = object as? UIImage{
                    DispatchQueue.main.async {
                        switch self?.imageTap{
                        case .coverImageTap:
                            self?.headerView.coverProfileImageView.image = image
                        case .avatarImageTap:
                            self?.headerView.avatarProfileImageView.image = image
                        case .none: break
                            
                        }
                    }
                    
                }
            }
        }
    }
}


enum EditProfileImagesTap{
    case coverImageTap
    case avatarImageTap
}
