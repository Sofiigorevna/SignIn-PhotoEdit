//
//  Alert.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 09.04.2024.
//

import UIKit

class ShowAlert: NSObject {
static let shared = ShowAlert()

    func alert(view: UIViewController, title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }

    private override init() {}
}
