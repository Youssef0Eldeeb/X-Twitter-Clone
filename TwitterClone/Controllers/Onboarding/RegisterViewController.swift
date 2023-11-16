//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 15/11/2023.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {

    private var viewModel = RegisterViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    // UI Components
    private let registerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your account"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .emailAddress
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.isSecureTextEntry = true
        return textField
    }()
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create account", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(named: "blueTwitterColor")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    
    //Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(registerTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        configureconstraints()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss)))
        registerButton.addTarget(self, action: #selector(registerBtnTap), for: .touchUpInside)
        bindViews()
    }
    
    @objc private func tapToDismiss(){
        view.endEditing(true)
    }
    
    @objc private func changeEmailField(){
        viewModel.email = emailTextField.text
        viewModel.validateRegistration()
    }
    
    @objc private func changePasswordField(){
        viewModel.password = passwordTextField.text
        viewModel.validateRegistration()
    }
    @objc private func registerBtnTap(){
        viewModel.createUser()
    }
    
    private func bindViews(){
        emailTextField.addTarget(self, action: #selector(changeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(changePasswordField), for: .editingChanged)
        
        viewModel.$isRegistrationValid.sink { [weak self] isValid in
            self?.registerButton.isEnabled = isValid
        }.store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            print(user)
        }.store(in: &subscriptions)
    }
    
    
    private func configureconstraints(){
        
        let registerLabelConstraints = [
            registerTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: registerTitleLabel.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let registerButtonConstraints = [
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 180),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(registerLabelConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
        
    }
    

}
