//
//  SceneDelegate.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 09.04.2024.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleSignInSwift



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
     
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        FirebaseApp.configure()
//        GIDSignIn.sharedInstance.clientID = FirebaseApp().options.clientID
        
        if (Auth.auth().currentUser != nil) {
            let viewController = ProfileViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController

        } else {
            let viewController = SignInViewController()
            self.window?.rootViewController = viewController
        }
        
        window?.makeKeyAndVisible()
    }
}
