//
//  CustomView.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 09.04.2024.
//

import UIKit

class CustomLoginView: UIView {
    
    typealias CompletionBlock = () -> Void
    var onCompletion: CompletionBlock?
    
    // MARK: - Outlets
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = .systemGray6
        return stackView
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.returnKeyType = .done
        textField.keyboardType = .emailAddress
        textField.textColor = .black
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.tintColor = UIColor.systemGray
        textField.autocapitalizationType = .none
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.returnKeyType = .done
        textField.textColor = .black
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.tintColor = UIColor.systemGray
        textField.isSecureTextEntry = true
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    var signInLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Регистрация"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in Cell")
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        self.addSubview(signInLabel)
        self.addSubview(textFieldStackView)
        self.addSubview(loginButton)
        self.addSubview(messageLabel)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            signInLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            
            messageLabel.bottomAnchor.constraint(equalTo: textFieldStackView.topAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            textFieldStackView.topAnchor.constraint(equalTo:  self.safeAreaLayoutGuide.topAnchor, constant: 120),
            textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    //: MARK: INPUTS
    
    @objc func loginButtonPressed() {
        self.onCompletion?()
    }
    
    // MARK: - Methods
    
    func setGradientBackground() {
        let violet = UIColor.purple.cgColor
        let white = UIColor.black.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [white,violet]
        gradientLayer.locations = [0.0, 0.8]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}
