//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 17/11/2023.
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    private var viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    // UI Components
    private let loginTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Log in to X"
        label.font = .systemFont(ofSize: 30, weight: .bold)
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
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .lightGray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(loginTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        configureconstraints()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss)))
        loginButton.addTarget(self, action: #selector(loginBtnTap), for: .touchUpInside)
        configureNavigationBar()
        bindViews()
    }
    @objc private func tapToDismiss(){
        view.endEditing(true)
    }
    @objc private func cancelBtnTap(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeEmailField(){
        viewModel.email = emailTextField.text
        viewModel.validateAuthentication()
    }
    
    @objc private func changePasswordField(){
        viewModel.password = passwordTextField.text
        viewModel.validateAuthentication()
    }
    
    @objc private func loginBtnTap(){
        viewModel.loginUser()
    }
    private func configureNavigationBar(){
        let size: CGFloat = 28
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "twitterLogo")
        
        let middelView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        middelView.addSubview(logoImageView)
        navigationItem.titleView = middelView
        
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelBtnTap))
        leftBarButton.tintColor = .label
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func bindViews(){
        emailTextField.addTarget(self, action: #selector(changeEmailField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(changePasswordField), for: .editingChanged)
        
        viewModel.$isAuthenticationValid.sink { [weak self] isValid in
            self?.loginButton.isEnabled = isValid
        }.store(in: &subscriptions)
        
        viewModel.$user.sink { [weak self] user in
            guard user != nil else {return}
            guard let vc = self?.navigationController?.viewControllers.first as? OnboardingViewController else {return}
            vc.dismiss(animated: true)
        }.store(in: &subscriptions)
        
        viewModel.$error.sink {[weak self] error in
            guard let error = error else {return}
            UIAlertController.showAlert(msg: error, form: self!)
        }.store(in: &subscriptions)
    }
    
    private func configureconstraints(){
        
        let loginLabelConstraints = [
            loginTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ]
        let emailTextFieldConstraints = [
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 20),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let passwordTextFieldConstraints = [
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let loginButtonConstraints = [
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(loginLabelConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        
    }

}
