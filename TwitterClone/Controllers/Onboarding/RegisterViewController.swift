//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 15/11/2023.
//

import UIKit
import Combine

class RegisterViewController: UIViewController {

    private var viewModel = AuthenticationViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    // UI Components
    private let registerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create your account"
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
    private let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "Date of birth",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "By signing up. you agree to the Terms of Service and Privacy Policy. including Cookie use. X may use your contact information, including your email adress and phone number for purposes outlined in our Privacy Policy, like Keeping your account secure and personalizing our services, including ads. Learn more. Others will be able to find you by email or phone number, when provided, unless you choose otherwise here."
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign up", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(named: "blueTwitterColor")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(registerTitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(birthdayTextField)
        view.addSubview(registerButton)
        view.addSubview(guideLabel)
        
        configureNavigationBar()
        configureconstraints()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToDismiss)))
        registerButton.addTarget(self, action: #selector(registerBtnTap), for: .touchUpInside)
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
    @objc private func registerBtnTap(){
        viewModel.createUser()
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
            self?.registerButton.isEnabled = isValid
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
        
        let registerLabelConstraints = [
            registerTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
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
        let birthdayTextFieldConstraints = [
            birthdayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            birthdayTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            birthdayTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            birthdayTextField.heightAnchor.constraint(equalToConstant: 60)
        ]
        let guideLabelConstraints = [
            guideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            guideLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            guideLabel.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -15)
        ]
        let registerButtonConstraints = [
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(registerLabelConstraints)
        NSLayoutConstraint.activate(emailTextFieldConstraints)
        NSLayoutConstraint.activate(passwordTextFieldConstraints)
        NSLayoutConstraint.activate(birthdayTextFieldConstraints)
        NSLayoutConstraint.activate(guideLabelConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
        
        
    }
    

}
