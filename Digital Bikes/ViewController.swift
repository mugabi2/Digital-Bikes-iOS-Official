//
//  ViewController.swift
//  Digital Bikes
//
//  Created by PSE on 20.03.23.
//

import SwiftTheme
import FirebaseAuth
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ThemeManager.setTheme(plistName: "Theme-Default", path: .mainBundle)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                
            //check if is signed in
            if Auth.auth().currentUser != nil {
                if let vc = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }else{
                if let vc = UIStoryboard(name: "SignIn", bundle: nil).instantiateInitialViewController() {
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
            
        }
        
    }


}

