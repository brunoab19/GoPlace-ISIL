//
//  HomeViewController.swift
//  GoPlace Driver
//
//  Created by Bruno Aburto on 5/11/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let user = firebaseGetUser() else {
            self.showAlertErrorCancel("Firebase",
                                      message: "An error has occurred",
                                      style: .alert,
                                      cancel: "OK")
            return
        }
        
        nameLabel.text = user.displayName
        
        guard let photo = user.photoURL else {
            return
        }
        
        photoImageView.load(url: photo)
    }
    
    @IBAction func tapToLogout(_ sender: Any) {
        do {
            try self.firebaseSignOut()
            self.navigationToAuth()
        }
        catch {
            self.showAlertErrorCancel("Firebase",
                                      message: error.localizedDescription,
                                      style: .alert,
                                      cancel: "OK")
        }
        
    }

}
