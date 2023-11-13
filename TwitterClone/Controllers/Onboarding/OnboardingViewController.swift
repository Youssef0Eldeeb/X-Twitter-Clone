//
//  OnboardingViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 13/11/2023.
//

import UIKit

class OnboardingViewController: UIViewController {

    //UIComponents
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "See what's happen in the world right now"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 32, weight: .heavy)
        return label
    }()
    let creatAcountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Acount", for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.tintColor = .white
        return button
    }()
    let promptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Have an acount aleardy?"
        label.tintColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1), for: .normal) 
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        view.addSubview(welcomeLabel)
        view.addSubview(creatAcountButton)
        view.addSubview(promptLabel)
        view.addSubview(loginButton)
        
        configureConstraints()
    }
    
    private func configureConstraints(){
        let welcomeLabelConstraints = [
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        let createAcountConstraints = [
            creatAcountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creatAcountButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            creatAcountButton.widthAnchor.constraint(equalTo: welcomeLabel.widthAnchor, constant: -40),
            creatAcountButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        let promptLabelConstraints = [
            promptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            promptLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ]
        let loginButtonConstrints = [
            loginButton.centerYAnchor.constraint(equalTo: promptLabel.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: promptLabel.trailingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(welcomeLabelConstraints)
        NSLayoutConstraint.activate(createAcountConstraints)
        NSLayoutConstraint.activate(promptLabelConstraints)
        NSLayoutConstraint.activate(loginButtonConstrints)
        
    }

}
