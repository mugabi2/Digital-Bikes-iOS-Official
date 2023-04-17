//
//  ProfileController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Lottie

class ProfileController: UIViewController {

    @IBOutlet weak var profile_picture: UIImageView!
    
    @IBOutlet weak var profile_card: UIView!
    
    @IBOutlet weak var profile_edit: UIView!
    
    
    @IBOutlet weak var phone_card: UIView!
    
    @IBOutlet weak var phone_text: UILabel!
    
    
    @IBOutlet weak var residence_card: UIView!
    
    @IBOutlet weak var residence_text: UILabel!
    
    
    @IBOutlet weak var digital_time_card: UIView!
    
    @IBOutlet weak var digital_time_text: UILabel!
    
    
    @IBOutlet weak var location_card: UIView!
    
    @IBOutlet weak var location_text: UILabel!
    
    
    @IBOutlet weak var buy_card: UIView!
    
    @IBOutlet weak var buy_animation: LottieAnimationView!
    
    
    @IBOutlet weak var sign_out_button: UIButton!
    
    @IBAction func sign_out_action(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
        }catch{}
        dismiss(animated: true)
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profile_card.layer.cornerRadius = profile_card.bounds.height / 2
        profile_edit.layer.cornerRadius = profile_edit.bounds.height / 2
        profile_picture.layer.cornerRadius = profile_picture.bounds.height / 2
        
        phone_card.layer.cornerRadius = 10
        sign_out_button.layer.cornerRadius = 10
        residence_card.layer.cornerRadius = 10
        digital_time_card.layer.cornerRadius = 10
        location_card.layer.cornerRadius = 10
        buy_card.layer.cornerRadius = 10
        
        sign_out_button.layer.cornerRadius = 10
        
        buy_animation.contentMode = .scaleAspectFit
        buy_animation.loopMode = .loop
        buy_animation.animationSpeed = 0.5
        buy_animation.play()
        
        
        displayUser()
        
        
        
        buy_card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buy_card_action(_:))))
        
        
    }
    
    
    
    @objc func buy_card_action(_ sender:UITapGestureRecognizer){
        if let vc = UIStoryboard(name: "DigitalTimePacks", bundle: nil).instantiateInitialViewController() {
            
            present(vc, animated: true)
            
        }
    }


    
    
    
    
    
    @IBOutlet weak var uiPhoneNumber: UILabel!
    
    func displayUser(){
        
        let defaults = UserDefaults.standard
        
        uiPhoneNumber.text = defaults.string(forKey: "phone_number")
        
        
    }

}
