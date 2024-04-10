//
//  SignInVC+.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 10.04.2024.
//

import Foundation
import Firebase
import GoogleSignIn

extension SignInViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

