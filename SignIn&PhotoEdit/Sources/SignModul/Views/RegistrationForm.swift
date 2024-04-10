//
//  RegistrationForm.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 09.04.2024.
//

import Foundation

struct RegistrationForm {
    var email: String
    var password: String
    
    // Метод для валидации данных
    func validate(completion: @escaping ((String?) -> Void)) {
        // Проверка наличия данных
        guard !email.isEmpty && !password.isEmpty else {
            completion("Все поля должны быть заполнены")
            return
        }
        
        // Проверка формата email
        guard email.isValidEmail else {
            completion("Введите корректный адрес электронной почты")
            return
        }
        
        // Проверка длины пароля
        guard password.count >= 6 else {
            completion("Пароль должен содержать не менее 6 символов")
            return
        }
       // completion("Данный аккаунт уже существует")

        return  // Все данные прошли валидацию
    }
}

// Расширение для проверки формата email
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}
