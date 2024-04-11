//
//  ViewModel.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 10.04.2024.
//

import Foundation
import Firebase
import GoogleSignIn

protocol ViewModelType {
    var isLoading: Dynamic<Bool> { get set }
    func registerUser(email: String, password: String)
    func signInUser(email: String, password: String)
    func signInGoogle()
}

class ViewModel {
    var isLoading: Dynamic<Bool> = Dynamic(false)
    
    func registerUser(email: String, password: String, vc: UIViewController) {
        isLoading.value = true
        
        // Создаем экземпляр модели данных для формы регистрации
        let registrationForm = RegistrationForm(email: email, password: password)
        
        // Проверяем валидность данных
        registrationForm.validate(completion: { message in
            guard let message = message else {
                return
            }
            
            ShowAlert.shared.alert(
                view: vc,
                title: "Oops!",
                message: message,
                completion: nil)
        })
        
        // Если данные прошли валидацию, регистрируем пользователя через Firebase
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                print("Ошибка при создании пользователя: \(error.localizedDescription)")
                ShowAlert.shared.alert(
                    view: vc,
                    title: "Error",
                    message: error.localizedDescription,
                    completion: nil)
            } else {
                if let result = authResult {
                    print(result.user.uid)
                    let ref = Database.database().reference().child("users")
                    ref.child(result.user.uid).updateChildValues(["email" : email])
                    self.isLoading.value = false
                    // Пользователь успешно создан
                    // Отправляем письмо с подтверждением email
                    result.user.sendEmailVerification(completion: { error in
                        if let error = error {
                            // Ошибка при отправке письма с подтверждением email
                            print("Ошибка при отправке письма с подтверждением email: \(error.localizedDescription)")
                            ShowAlert.shared.alert(
                                view: vc,
                                title: "Oops!",
                                message: "Ошибка при отправке письма с подтверждением email",
                                completion: nil)
                        } else {
                            ShowAlert.shared.alert(
                                view: vc,
                                title: "",
                                message: "Письмо с подтверждением email успешно отправлено",
                                completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    // метод входа в систему
    func signInUser(email: String, password: String, vc: UIViewController) {
        isLoading.value = true
        
        // Создаем экземпляр модели данных для формы регистрации
        let registrationForm = RegistrationForm(email: email, password: password)
        
        // Проверяем валидность данных
        registrationForm.validate(completion: {  message in
            guard let message = message else {
                return
            }
            
            ShowAlert.shared.alert(
                view: vc,
                title: "Oops!",
                message: message,
                completion: nil)
        })
        
        // Если данные прошли валидацию, осуществляем вход
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self else {
                return
            }
            
            self.isLoading.value = false
            
            if let error = error {
                print("Ошибка при входе в акк: \(error.localizedDescription)")
                ShowAlert.shared.alert(
                    view: vc,
                    title: "Error",
                    message: "Возможно допущена ошибка в пароле, перепроверьте данные",
                    completion: nil)
            } else {
                vc.dismiss(animated: true)
            }
        }
    }
    
    func signInGoogle(vc: UIViewController) {
        isLoading.value = true
        let clientID = "314380970987-1be5qpjccemlln4n0imcol4jcdmkom9b.apps.googleusercontent.com"
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { [weak self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential){ [weak self] (authResult, error) in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    print("Ошибка при входе в акк: \(error.localizedDescription)")
                    ShowAlert.shared.alert(
                        view: vc,
                        title: "Error",
                        message: "Error",
                        completion: nil)
                } else {
                    if let result = authResult {
                        self.isLoading.value = false
                        print(result.user.uid)
                        vc.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
