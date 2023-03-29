//
//  SignInController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import UIKit
import FirebaseAuth

class SignInController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        bg.layer.cornerRadius = 10
        login_button.layer.cornerRadius = 10
        
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = Auth.auth().currentUser  {
                    
                let uid = user.uid
                let email = user.email
                let displayName = user.displayName
                let photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                  
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
                
                print(" \(uid), \(email), \(photoURL), \(displayName)  ")
                
            } else {
              // No user is signed in.
              // ...
            }
        }
        
    }
    
    @IBOutlet weak var login_button: UIButton!
    
    @IBAction func login_action(_ sender: Any) {
        
        if let home = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() {
            home.modalPresentationStyle = .fullScreen
            present(home, animated: true)
        }
        
        
        
    }
    
    
    @IBOutlet weak var register_button: UIButton!
    
    @IBAction func register_action(_ sender: Any) {
        if let home = UIStoryboard(name: "SignUp", bundle: nil).instantiateInitialViewController() {
            home.modalPresentationStyle = .fullScreen
            present(home, animated: true)
        }
    }
    
    
    @IBOutlet weak var bg: UIView!
    
    
}
