//
//  SignUpController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var bg: UIView!
    
    
    @IBOutlet weak var sign_up_button: UIButton!
    
    @IBAction func sign_up_action(_ sender: Any) {
        
    }
    
    
    
    @IBAction func login_link(_ sender: Any) {
        
    }
    
    @IBOutlet weak var gender_button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gender_button.layer.cornerRadius = 10
        sign_up_button.layer.cornerRadius = 10
        bg.layer.cornerRadius = 10

    }
    
}
