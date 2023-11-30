//
//  TweetViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 29/11/2023.
//

import UIKit

class TweetViewController: UIViewController {

    private lazy var leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(cancelBtnTap))
        button.title = "Cancel"
        button.tintColor = .label
        return button
    }()
    private lazy var rightBarButton: UIBarButtonItem = {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 36))
        customView.backgroundColor = UIColor(named: "blueTwitterColor")
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = 18
        
        let button = UIButton(frame: customView.bounds)
        button.addTarget(self, action: #selector(postBtnTap), for: .touchUpInside)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = .white
        customView.addSubview(button)
        
        let customBarButtonItem = UIBarButtonItem(customView: customView)
        return customBarButtonItem
    }()
    private lazy var tweetTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .gray
        textView.text = "What's happening?"
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        congigureNavigationBar()
        view.addSubview(tweetTextView)
        configureConstraints()
        tweetTextView.delegate = self
    }
    
    @objc private func cancelBtnTap(){
        self.dismiss(animated: true)
    }
    @objc private func postBtnTap(){
        self.dismiss(animated: true)
    }
    private func congigureNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton      
    }
    private func configureConstraints() {
        let tweetTextViewConstraints = [
            tweetTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tweetTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tweetTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tweetTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(tweetTextViewConstraints)
    }


}


extension TweetViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.textColor = .label
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "What's happening?"
            textView.textColor = .gray
        }
    }
}
