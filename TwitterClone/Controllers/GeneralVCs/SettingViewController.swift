//
//  SettingViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 12/11/2023.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {

    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(named: "blueTwitterColor")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Setting"
        self.view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logoutTap), for: .touchUpInside)
        
        configureConstraints()
    }
    
    @objc private func logoutTap(){
        let alert = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            try? Auth.auth().signOut()
            self?.handleAuthentication()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
        
    }
    
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            navigationController?.popViewController(animated: true)
            SceneDelegate().window?.rootViewController = vc
        }
    }
    
    private func configureConstraints(){
        let logoutBtnConstraints = [
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 180),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(logoutBtnConstraints)
    }
    

}
