//
//  ViewController.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 09.04.2024.
//

import UIKit
import Firebase
import GoogleSignInSwift
import GoogleSignIn

class SignInViewController: UIViewController {
    
    // MARK: - State

    var viewModel = ViewModel()
    private var signUp: Bool = true
    
    // MARK: - Outlets
    
    private lazy var loginView: CustomLoginView = {
        let view = CustomLoginView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "У вас уже есть аккаунт?"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(switchLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var restorePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Восстановить пароль", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(restorePassword), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        button.colorScheme = .light
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        bindViewModel()
        pushProfile()
        setupHierarhy()
        setupLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginView.setGradientBackground()
    }
    
    // MARK: - Setup
    
    private func setupHierarhy() {
        view.addSubview(loginView)
        view.addSubview(messageLabel)
        view.addSubview(signInButton)
        view.addSubview(restorePasswordButton)
        view.addSubview(googleSignInButton)
        view.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.widthAnchor.constraint(equalToConstant: view.frame.width),
            loginView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loginView.heightAnchor.constraint(equalToConstant: 381),
            
            messageLabel.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 30),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signInButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restorePasswordButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            restorePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            googleSignInButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor,constant: 70),
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc func switchLogin() {
        signUp.toggle()
        loginView.signInLabel.text = "Вход"
        messageLabel.text = "Забыли пароль?"
        signInButton.isHidden = true
        restorePasswordButton.isHidden = false
        googleSignInButton.isHidden = false
    }
    @objc func googleLogin() {
        self.viewModel.signInGoogle(vc: self)
    }
    
    @objc func restorePassword() {
        present(PasswordResetViewController(), animated: true)
    }
    
    // MARK: - Methods
    
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self, let isLoading else {return}
            DispatchQueue.main.async {
                isLoading ? self.activityIndicator.startAnimating() :  self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func pushProfile() {
        loginView.onCompletion = { [weak self] in
            guard let self = self,
                  let userEmail = self.loginView.emailTextField.text,
                  let password = self.loginView.passwordTextField.text else {
                return
            }
            
            if self.signUp {
                self.viewModel.registerUser(email: userEmail, password: password, vc: self)
            } else {
                self.viewModel.signInUser(email: userEmail, password: password, vc: self)
            }
        }
    }
}

