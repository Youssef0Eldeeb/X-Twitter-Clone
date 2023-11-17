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
        try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
//            navigationController?.popViewController(animated: false)
            present(vc, animated: false)
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
