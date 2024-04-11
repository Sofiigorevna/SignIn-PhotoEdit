//
//  ProfileViewController.swift
//  SignIn&PhotoEdit
//
//  Created by 1234 on 09.04.2024.
//
import SwiftUI
import UIKit
import Firebase
import CropViewController

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Outlets
    
    lazy var galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitle("Open photo gallery", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        title = "Photo editor"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Exit profile",
            style: .plain,
            target: self,
            action: #selector(signOut))
    }
    
    private func setupHierarchy() {
        view.addSubview(galleryButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            galleryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            galleryButton.widthAnchor.constraint(equalToConstant: 200),
            galleryButton.heightAnchor.constraint(equalToConstant: 50),
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
    
    @objc func didTapAdd() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            
            picker.dismiss(animated: true)
            showCrop(image: image)
            
        }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Done"
        vc.doneButtonColor = .white
        vc.cancelButtonTitle = "Back"
        vc.cancelButtonColor = .systemRed
        vc.delegate = self
        
        present(vc, animated: true)
    }
}

extension ProfileViewController: CropViewControllerDelegate {
    func cropViewController(
        _ cropViewController: CropViewController,
        didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true)
        }
    
    func cropViewController(
        _ cropViewController: CropViewController,
        didCropToImage image: UIImage,
        withRect cropRect: CGRect,
        angle: Int) {
            cropViewController.dismiss(animated: true)
            let media = MediaItem(type: .image, image: image, video: nil, videoUrl: nil)
            let vc = EditorView(media: media) {
                print("VC EditorView")
            }
            let hosting = UIHostingController(rootView: vc)
            navigationController?.pushViewController(hosting, animated: true)
        }
}






