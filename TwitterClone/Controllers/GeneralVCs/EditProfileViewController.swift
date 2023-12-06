//
//  ProfileDataFormViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 18/11/2023.
//

import UIKit
import PhotosUI
import Combine

protocol EditProfileDelegate{
    func coverImageDidTap()
    func avatarImageDidTap()
}

class EditProfileViewController: UIViewController {
    
    var headerView: EditProfileHeaderView!
    var imageTap: EditProfileImagesTap?
    var viewModel = EditProfileViewModel()
    var subscription: Set<AnyCancellable> = []
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private let leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Cancel"
        button.style = .done
        button.tintColor = .label
        return button
    }()
    private let rightBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Save"
        button.style = .done
        button.tintColor = .label
        button.isHidden = true
        return button
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
        bindView()
    }
    
    @objc private func cancelBtnTap(){
        self.dismiss(animated: true)
    }
    @objc private func saveBtnTap(){
        viewModel.uploadAvatar()
        
    }
    @objc private func tapToDismiss(){
        view.endEditing(true)
    }
    @objc private func didUpdateName(){
        let indexPath = IndexPath(row: 0, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.name = cell.textField.text
        }
        viewModel.validateUserProfile()
    }
    @objc private func didUpdateUsername(){
        let indexPath = IndexPath(row: 1, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.username = cell.textField.text
        }
        viewModel.validateUserProfile()
    }
    @objc private func didUpdateBio(){
        let indexPath = IndexPath(row: 2, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.bio = cell.textField.text
        }
    }
    @objc private func didUpdateLocation(){
        let indexPath = IndexPath(row: 3, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.location = cell.textField.text
        }
    }
    @objc private func didUpdateBirthDate(){
        let indexPath = IndexPath(row: 5, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.birthDate = cell.textField.text
        }
    }
    @objc private func didUpdateWebsite(){
        let indexPath = IndexPath(row: 4, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell {
            viewModel.website = cell.textField.text
        }
    }
    
    private func congigureNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationItem.title = "Edit profile"
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        leftBarButton.target = self
        leftBarButton.action = #selector(cancelBtnTap)
        rightBarButton.target = self
        rightBarButton.action = #selector(saveBtnTap)
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
    private func bindView(){
        viewModel.$isFormValid.sink { [weak self] buttonState in
            if buttonState {
                self?.rightBarButton.isHidden = false
            }else{
                self?.rightBarButton.isHidden = true
            }
        }.store(in: &subscription)
        
        viewModel.$isOnboarding.sink { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }.store(in: &subscription)
        
        
    }
    private func setUserDataAsDefualtData(){
        let indexPath = IndexPath(row: 3, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? EditProfileTableViewCell{
            
        }
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
            cell.textField.addTarget(self, action: #selector(didUpdateName), for: .editingChanged)
        case 1:
            cell.title.text = "Username"
            cell.textField.placeholder = "Add your username"
            cell.textField.addTarget(self, action: #selector(didUpdateUsername), for: .editingChanged)
        case 2:
            cell.title.text = "Bio"
            cell.textField.placeholder = "Add a Bio to your profile"
            cell.textField.addTarget(self, action: #selector(didUpdateBio), for: .editingChanged)
        case 3:
            cell.title.text = "Location"
            cell.textField.placeholder = "Add your location"
            cell.accessoryType = .disclosureIndicator
            cell.textField.addTarget(self, action: #selector(didUpdateLocation), for: .editingChanged)
        case 4:
            cell.title.text = "Website"
            cell.textField.placeholder = "Add your website"
            cell.accessoryType = .disclosureIndicator
            cell.textField.addTarget(self, action: #selector(didUpdateWebsite), for: .editingChanged)
        case 5:
            cell.title.text = "Birth date"
            cell.textField.placeholder = "Add your birth date"
            cell.textField.addTarget(self, action: #selector(didUpdateBirthDate), for: .editingChanged)
        case 6:
            cell.textLabel?.text = "Switch to Professional"
            cell.title.isHidden = true
            cell.textField.isHidden = true
            cell.accessoryType = .disclosureIndicator
        case 7:
            cell.title.isHidden = true
            cell.textField.isHidden = true
        case 8:
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
        case 2:
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
                            self?.viewModel.coverImageData = image
                        case .avatarImageTap:
                            self?.headerView.avatarProfileImageView.image = image
                            self?.viewModel.avatarImageData = image
                            self?.viewModel.validateUserProfile()
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
