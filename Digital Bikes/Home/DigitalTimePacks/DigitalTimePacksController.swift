//
//  DigitalTimePacksController.swift
//  Digital Bikes
//
//  Created by PSE on 17.04.23.
//

import UIKit
import Lottie
import SwiftyJSON
import FlutterwaveSDK
import SwiftTheme
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class DigitalTimePacksController: UIViewController {
    
    let defaults = UserDefaults.standard
    let flutter_public_key = "FLWPUBK-c344ed9966c669c2a626e7f163242320-X"
    let flutter_encryption = "c0c81d3c01db24a740abc608"
    
    @IBOutlet weak var sliding_indicator: UIView!
    
    
    
    @IBOutlet weak var card_hour_glass: UIView!
    
    @IBOutlet weak var card_hour_glass_in: UIView!
    
    @IBOutlet weak var animation_hour_glass: LottieAnimationView!
    
    
    @IBOutlet weak var card_time_bucket: UIView!
    
    @IBOutlet weak var card_time_bucket_in: UIView!
    
    @IBOutlet weak var animation_time_bucket: LottieAnimationView!
    
    
    @IBOutlet weak var uiactivity: UIActivityIndicatorView!
    
    
    @IBOutlet weak var btn500: UIButton!
    
    @IBAction func btn500action(_ sender: UIButton) {
        digital_time = "20"
        digital_time_amount = "500"
        self.invokeFlutterwave()
    }
    
    
    var current_digital_time = "0"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            btn500.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
        sliding_indicator.layer.cornerRadius = 10
        
        card_hour_glass.layer.cornerRadius = 10
        card_hour_glass_in.layer.cornerRadius = 10
        animation_hour_glass.contentMode = .scaleAspectFit
        animation_hour_glass.loopMode = .loop
        animation_hour_glass.animationSpeed = 0.5
        animation_hour_glass.play()
        
        card_time_bucket.layer.cornerRadius = 10
        card_time_bucket_in.layer.cornerRadius = 10
        animation_time_bucket.contentMode = .scaleAspectFit
        animation_time_bucket.loopMode = .loop
        animation_time_bucket.animationSpeed = 0.5
        animation_time_bucket.play()
        
        card_time_bucket.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(card_time_bucket_action(_:))))
        card_hour_glass.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(card_hour_glass_action(_:))))
        
        self.uiactivity.stopAnimating()
        
        current_digital_time = self.defaults.string(forKey: "digital_time") ?? "0"
        let email = self.defaults.string(forKey: "email") ?? ""
        let firstname = self.defaults.string(forKey: "firstname") ?? ""
        let surname = self.defaults.string(forKey: "surname") ?? ""
        let residence = self.defaults.string(forKey: "residence") ?? ""
        let phone_number = self.defaults.string(forKey: "phone_number") ?? ""
    }
    
    func invokeFlutterwave(){
        self.payWithFlutterwave(txRef: UUID().uuidString, currency: "UGX", amount: digital_time_amount)
    }
    
    var digital_time = ""
    var digital_time_amount = ""
    
    @objc func card_time_500_action(_ sender:UITapGestureRecognizer){
        digital_time = "20"
        digital_time_amount = "500"
        self.invokeFlutterwave()
    }
    
    @objc func card_time_bucket_action(_ sender:UITapGestureRecognizer){
        digital_time = "420"
        digital_time_amount = "10000"
        self.invokeFlutterwave()
    }
    
    @objc func card_hour_glass_action(_ sender:UITapGestureRecognizer){
        digital_time = "60"
        digital_time_amount = "1500"
        self.invokeFlutterwave()
    }
    
    func incrementUserDigitalTime(){
        
        print( "Adding- \(current_digital_time)" )
        print( "Adding= \(digital_time)" )
        print( "Adding+ \( Int( current_digital_time )! + Int( digital_time )! )")
        
        
        let dataOne : [String : String] = [
            "digital_time": "\( Int( current_digital_time )! + Int( digital_time )! )",
        ]
        
        
        
        self.uiactivity.startAnimating()
        self.uiactivity.isHidden = false
        
        let db = Firestore.firestore()
        // Add the document to the "mukusers" collection with the phone number as the document ID
        db.collection("mukusers").document(self.defaults.string(forKey: "phone_number") ?? "").updateData(dataOne) { error in
            if let error = error {
                // Handle the error
                print("Error adding document: \(error.localizedDescription)")
                showPopUpMessageHelper(controller: self, title: "Error", message: "Request failed to Save")
                
                self.uiactivity.stopAnimating()
                
                //self.btnRequestAgent.isHidden = false
                
                
            } else {
                // Document added successfully
                print("Request Document updated successfully")
                self.uiactivity.stopAnimating()
                
                let alertController = UIAlertController(title: "Topup successful", message: "You can now proceed to order a ride", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(dismissAction)
                self.present(alertController, animated: true, completion: nil)
                
                
            }
        }
    }

}


extension DigitalTimePacksController : FlutterwavePayProtocol {
    
    func onDismiss() {
    }
    
    func tranasctionSuccessful(flwRef: String?, responseData: FlutterwaveDataResponse?) {
        //self.dismiss(animated: true)
        incrementUserDigitalTime()
    }
    
    func tranasctionFailed(flwRef: String?, responseData: FlutterwaveDataResponse?) {
    }
    
    func payWithFlutterwave(txRef: String, currency : String, amount : String ){
        
        print( digital_time )
        print( digital_time_amount )
        
        let digital_time = self.defaults.string(forKey: "digital_time") ?? ""
        let email = self.defaults.string(forKey: "email") ?? ""
        let firstname = self.defaults.string(forKey: "firstname") ?? ""
        let surname = self.defaults.string(forKey: "surname") ?? ""
        let residence = self.defaults.string(forKey: "residence") ?? ""
        let phone_number = self.defaults.string(forKey: "phone_number") ?? ""
        
        let config = FlutterwaveConfig.sharedConfig()
        config.paymentOptionsToExclude = []
        config.currencyCode = currency // This is the specified currency to charge in.
        config.email = email // This is the email address of the customer
        config.isStaging = false // Toggle this for staging and live environment
        config.phoneNumber = phone_number //Phone number
        config.transcationRef = txRef // This is a unique reference, unique to the particular transaction being carried out. It is generated when it is
        config.firstName = firstname // This is the customers first name.
        config.lastName = surname //This is the customers last name.
        config.meta = [["metaname":"sdk", "metavalue":"ios"]] //This is used to include additional payment information
        config.narration = "Payment"
        config.publicKey = flutter_public_key //Public key
        config.encryptionKey = flutter_encryption //Encryption key
        config.isPreAuth = false  // This should be set to true for preauthorize card transactions
        let controller = FlutterwavePayViewController()
        let nav = UINavigationController(rootViewController: controller)
        controller.amount = amount // This is the amount to be charged.
        controller.delegate = self
        self.present(nav, animated: true)
    }
    
    
    
    
    
}
