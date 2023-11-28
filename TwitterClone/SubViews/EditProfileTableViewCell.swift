//
//  EditProfileTableViewCell.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 26/11/2023.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {

    static let identifier = String(describing: TweetTableViewCell.self)
    
    // MARK: - UI Components
    var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "text"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .default
        textField.backgroundColor = .systemBackground
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(string: "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(textField)
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints(){
        let titleConstraints = [
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            title.widthAnchor.constraint(equalToConstant: 70)
        ]
        let textFieldConstraints = [
            textField.topAnchor.constraint(equalTo: title.topAnchor),
            textField.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            textField.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(textFieldConstraints)
    }

}
