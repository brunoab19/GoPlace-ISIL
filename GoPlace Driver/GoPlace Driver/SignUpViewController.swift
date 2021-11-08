//
//  SignUpViewController.swift
//  GoPlace Driver
//
//  Created by Bruno Aburto on 2/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var anchorBottomConstraint: NSLayoutConstraint!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupImagePicker()
        setupImageViewTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }

    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func firstNameTextFieldChanged(_ sender: Any) {
        let text = (sender as AnyObject).text ?? ""
        
        if !text.isEmpty {
            firstNameView.borderWidthAndColor(0, color: UIColor.clear)
        }
        else {
            firstNameView.borderWidthAndColor(1, color: UIColor.red)
        }
    }
    
    @IBAction func lastNameFieldChanged(_ sender: Any) {
        let text = (sender as AnyObject).text ?? ""
        
        if !text.isEmpty {
            lastNameView.borderWidthAndColor(0, color: UIColor.clear)
        }
        else {
            lastNameView.borderWidthAndColor(1, color: UIColor.red)
        }
    }
    
    @IBAction func emailTextFieldChanged(_ sender: Any) {
        let text = (sender as AnyObject).text ?? ""
        
        if text.isValidEmail() {
            emailView.borderWidthAndColor(0, color: UIColor.clear)
        }
        else {
            emailView.borderWidthAndColor(1, color: UIColor.red)
        }
    }
    
    @IBAction func passwordTextFieldChanged(_ sender: Any) {
        let text = (sender as AnyObject).text ?? ""
        
        if text.isValidPassword() {
            passwordView.borderWidthAndColor(0, color: UIColor.clear)
        }
        else {
            passwordView.borderWidthAndColor(1, color: UIColor.red)
        }
    }
    
    @IBAction func confirmPasswordTextFieldChanged(_ sender: Any) {
        let text = (sender as AnyObject).text ?? ""
        
        if (text.isValidPassword() && text == passwordTextField.text) {
            confirmPasswordView.borderWidthAndColor(0, color: UIColor.clear)
        }
        else {
            confirmPasswordView.borderWidthAndColor(1, color: UIColor.red)
        }
    }

    @IBAction func tapToSignUp(_ sender: Any) {
        firebaseSignUp()
    }
    
    @IBAction func tapToGoToSignInScreen(_ sender: Any) {
        navigationPopEvent()
    }
    
}

// MARK: - Keyboards Events
extension SignUpViewController {
    
    func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterKeyboardEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomConstraint.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - ImagePicker Events
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupImagePicker() {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
    }
    
    func launchImagePicker() {
        present(self.imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photoImageView?.image = image
            self.photoImageView.contentMode = .scaleToFill
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - ImageView Tapped Events
extension SignUpViewController {
    
    func setupImageViewTapGesture() {
        self.photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTapped)))
    }
    
    @objc func imageTapped() {
        launchImagePicker()
    }
    
}

// MARK: - Loading Events
extension SignUpViewController {
    
    func showLoading() {
        self.loadingActivityIndicatorView.startAnimating()
        self.loadingView.isHidden = false
    }
    
    func hideLoading() {
        self.loadingActivityIndicatorView.stopAnimating()
        self.loadingView.isHidden = true
    }
    
}

// MARK: - Firebase Events
extension SignUpViewController {
    
    func firebaseSignUp() {
        if self.photoImageView.image == UIImage.init(systemName: "camera") {
            showAlertErrorCancel("Photo",
                                 message: "You must choose a profile picture for your account.",
                                 style: .alert,
                                 cancel: "OK")
            
            return
        }
        
        
        let firstName = self.firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if firstName.isEmpty {
            showAlertErrorCancel("First Name",
                                 message: "The first name must not be empty.",
                                 style: .alert,
                                 cancel: "OK")
            
            firstNameView.borderWidthAndColor(1, color: UIColor.red)
            return
        }
        
        let lastName = self.lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if lastName.isEmpty {
            showAlertErrorCancel("Last Name",
                                 message: "The last name must not be empty.",
                                 style: .alert,
                                 cancel: "OK")
            
            lastNameView.borderWidthAndColor(1, color: UIColor.red)
            return
        }
        
        let email = self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !email.isValidEmail() {
            showAlertErrorCancel("Email",
                                 message: "The email entered does not have the correct format.",
                                 style: .alert,
                                 cancel: "OK")
            
            emailView.borderWidthAndColor(1, color: UIColor.red)
            return
        }
        
        let password = self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if !password.isValidPassword() {
            showAlertErrorCancel("Password",
                                 message: "The password must be a minimum of 8 characters, at least 1 uppercase alphabet, 1 lowercase alphabet, 1 number and 1 special character.",
                                 style: .alert,
                                 cancel: "OK")
            
            passwordView.borderWidthAndColor(1, color: UIColor.red)
            return
        }
        
        let confirmPassword = self.confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if (!confirmPassword.isValidPassword() || confirmPassword != password) {
            showAlertErrorCancel("Confirm Password",
                                 message: "The confirmation password must be equal to the password and must have a minimum of 8 characters, at least 1 uppercase alphabet, 1 lowercase alphabet, 1 number and 1 special character.",
                                 style: .alert,
                                 cancel: "OK")
            
            confirmPasswordView.borderWidthAndColor(1, color: UIColor.red)
            return
        }
        
        showLoading()
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let result = result else {
                self.hideLoading()
                self.showAlertErrorCancel("Firebase",
                                     message: error?.localizedDescription,
                                     style: .alert,
                                     cancel: "OK")
                return
            }
            
            let user = result.user
            let storageRef = Storage.storage().reference()
            let profileRef = storageRef.child("profiles/\(user.uid).jpg")
            guard let data = self.photoImageView.image?.jpegData(compressionQuality: 0.5) else {
                self.hideLoading()
                return
            }
            
            profileRef.putData(data, metadata: nil) { metadata, error in
                guard let metadata = metadata else {
                    self.hideLoading()
                    self.showAlertErrorCancel("Firebase",
                                         message: error?.localizedDescription,
                                         style: .alert,
                                         cancel: "OK")
                    return
                }
                
                profileRef.downloadURL { url, error in
                    guard let url = url else {
                        self.hideLoading()
                        self.showAlertErrorCancel("Firebase",
                                             message: error?.localizedDescription,
                                             style: .alert,
                                             cancel: "OK")
                        return
                    }
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "\(firstName) \(lastName)"
                    changeRequest.photoURL = url.absoluteURL
                    changeRequest.commitChanges { error in
                        guard let error = error else {
                            self.hideLoading()
                            self.showAlertWithOnlyDefaultAction("Firebase",
                                                           message: "The user registered successfully.",
                                                           style: .alert,
                                                           accept: "Go to Home") { action in
                                
                                self.navigationToMain()
                            }
                            return
                        }
                        
                        self.hideLoading()
                        self.showAlertErrorCancel("Firebase",
                                             message: error.localizedDescription,
                                             style: .alert,
                                             cancel: "OK")
                    }
                }
            }
        }
    }
    
}

