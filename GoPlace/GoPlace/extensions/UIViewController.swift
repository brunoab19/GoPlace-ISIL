//
//  UIViewController.swift
//  GoPlace
//
//  Created by Bruno Aburto on 2/11/21.
//

import UIKit
import FirebaseAuth

// MARK: - Navigation Events
extension UIViewController {
    
    func navigationPopEvent() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTBC = storyboard.instantiateViewController(withIdentifier: "MainTBC")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTBC)
    }
    
    func navigationToAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authNC = storyboard.instantiateViewController(withIdentifier: "AuthNC")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(authNC)
    }
    
}

// MARK: - Alert Manager
extension UIViewController {
    
    func showAlert(_ title: String?,
                   message: String?,
                   style: UIAlertController.Style,
                   accept: String?,
                   cancel: String?,
                   acceptAction: ((UIAlertAction) -> Void)?,
                   cancelAction: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if accept != nil {
            let actionAccept = UIAlertAction(title: accept, style: .default, handler: acceptAction)
            alert.addAction(actionAccept)
        }
        
        if cancel != nil {
            let actionCancel = UIAlertAction(title: cancel, style: .destructive, handler: cancelAction)
            alert.addAction(actionCancel)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertErrorDefault(_ title: String?,
                        message: String?,
                        style: UIAlertController.Style,
                        accept: String) {
        showAlert(title, message: message, style: style, accept: accept, cancel: nil, acceptAction: nil, cancelAction: nil)
    }
    
    func showAlertErrorCancel(_ title: String?,
                        message: String?,
                        style: UIAlertController.Style,
                        cancel: String) {
        showAlert(title, message: message, style: style, accept: nil, cancel: cancel, acceptAction: nil, cancelAction: nil)
    }
    
    func showAlertWithOnlyDefaultAction(_ title: String?,
                                        message: String?,
                                        style: UIAlertController.Style,
                                        accept: String,
                                        action: @escaping (UIAlertAction) -> Void) {
        showAlert(title, message: message, style: style, accept: accept, cancel: nil, acceptAction: action, cancelAction: nil)
    }
    
    func showAlertWithOnlyCancelAction(_ title: String?,
                                        message: String?,
                                        style: UIAlertController.Style,
                                        cancel: String,
                                        action: @escaping (UIAlertAction) -> Void) {
        showAlert(title, message: message, style: style, accept: nil, cancel: cancel, acceptAction: nil, cancelAction: action)
    }
}

// MARK: - Firebase Global Events
extension UIViewController {
    
    func firebaseGetUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func firebaseSignOut() throws {
        try Auth.auth().signOut()
    }
    
}
