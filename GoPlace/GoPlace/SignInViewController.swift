//
//  SignInViewController.swift
//  GoPlace
//
//  Created by Bruno Aburto on 2/11/21.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var anchorBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func tapToSignIn(_ sender: Any) {
        firebaseSignIn()
    }
    
}

// MARK: - Keyboards Events
extension SignInViewController {
    
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

// MARK: - Loading Events
extension SignInViewController {
    
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
extension SignInViewController {
    
    func firebaseSignIn() {
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
        
        showLoading()
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                self.hideLoading()
                self.showAlertErrorCancel("Firebase",
                                     message: error?.localizedDescription,
                                     style: .alert,
                                     cancel: "OK")
                return
            }
            
            self.hideLoading()
            self.navigationToMain()
        }
    }
    
}
