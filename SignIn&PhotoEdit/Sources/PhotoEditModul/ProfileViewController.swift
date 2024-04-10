//
//  ProfileViewController.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 09.04.2024.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    private var welcomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Welcome"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHierarhy()
        setupLayout()
    }
    

    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(signOut))
        //UIBarButtonItem(image: UIImage(named: "account 1"), style: .plain, target: self, action: #selector(signOut))
    }
    
    private func setupHierarhy() {
        view.addSubview(welcomeLabel)
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

        ])
    }
    
    // MARK: - Actions
    
    @objc func signOut() {
        do{
          try Auth.auth().signOut()
            let viewController = SignInViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true)
            
        } catch let signOutError as NSError{
            print(signOutError)
        }
    }
}
