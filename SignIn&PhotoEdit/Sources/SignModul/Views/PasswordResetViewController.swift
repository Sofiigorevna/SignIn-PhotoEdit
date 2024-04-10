//
//  PasswordResetViewController.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 10.04.2024.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "Необходимо ввести email для отправки инструкций по сбросу пароля"
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        return label
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
    lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarhy()
        setupLayout()
    }
    
    func setupHierarhy() {
        view.addSubview(emailTextField)
        view.addSubview(resetPasswordButton)
        view.addSubview(messageLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 120),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.widthAnchor.constraint(equalToConstant: 300),
            messageLabel.heightAnchor.constraint(equalToConstant: 70),
            
            emailTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 270),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            
            resetPasswordButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetPasswordButton.widthAnchor.constraint(equalToConstant: 100),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 40),

        ])
    }
    
    @objc func resetPasswordButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            ShowAlert.shared.alert(
                view: self,
                title: "Error",
                message: "Необходимо ввести email",
                completion: nil)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                ShowAlert.shared.alert(
                    view: self,
                    title: "Error",
                    message: "Ошибка при отправке инструкций по сбросу пароля. Повторите еще раз.",
                completion: nil)
                
                print("Ошибка при отправке инструкций по сбросу пароля: \(error.localizedDescription)")
            } else {
                ShowAlert.shared.alert(
                    view: self,
                    title: "Успешно",
                    message: "Инструкции по сбросу пароля успешно отправлены на email: \(email)") {
                        self.dismiss(animated: true, completion: nil)
                    }
            }
        }
    }
}
