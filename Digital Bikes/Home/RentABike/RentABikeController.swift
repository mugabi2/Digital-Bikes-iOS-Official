//
//  RentABikeController.swift
//  Digital Bikes
//
//  Created by PSE on 16.04.23.
//

import UIKit
import SwiftTheme
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class RentABikeController: UIViewController {
    
    
    let defaults = UserDefaults.standard
    var ustation : String? = nil
    
    var udura : String? = nil
    var tvduration : String? = nil
    var tvprice : String? = nil
    var radica : String? = nil
    
    
    @IBOutlet weak var uistation: UILabel!
    
    @IBOutlet weak var uiprice: UILabel!
    
    @IBOutlet weak var uiduration: UILabel!
    
    @IBOutlet weak var uicash: UILabel!
    
    @IBOutlet weak var uidigitaltime: UILabel!
    
    @IBOutlet weak var uiplansegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var uistackview_main1: UIStackView!
    @IBOutlet weak var uistackview_main2: UIStackView!
    @IBOutlet weak var uistackview_requested: UIStackView!
    
    
    func toggleProgress(position : Int){
        
        if position == 0 {
            tvduration = "20";
            udura = "20 mins";
            tvprice = "500";
            radica = "Cash 500";
        }else if position == 1 {
            tvduration = "40";
            udura = "40 mins";
            tvprice = "1000";
            radica = "Cash 1000";
        }else if position == 2 {
            tvduration = "60";
            udura = "1 hr";
            tvprice = "1500";
            radica = "Cash 1500";
        }else {
            
        }
        
        uicash.text = tvprice
        uiprice.text = tvprice
        uiduration.text = udura
        
    }
    
    
    @IBOutlet weak var card_mobile: UIView!
    
    @IBOutlet weak var card_wallet: UIView!
    
    @IBAction func action_cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var slide_down_indicator: UIView!
    
    @IBOutlet weak var uiactivity: UIActivityIndicatorView!
    
    
    var pay_using = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uistation.text = ustation
        slide_down_indicator.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
        button_proceed.layer.cornerRadius = 20
        
        card_mobile.layer.cornerRadius = 20
        card_wallet.layer.cornerRadius = 20
        
        card_mobile.layer.borderWidth = 5
        card_wallet.layer.borderWidth = 5
        
        card_wallet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(card_wallet_action(_:))))
        card_mobile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(card_mobile_action(_:))))
        
        logic_mobile()
        
        uiactivity.stopAnimating()
        uiactivity.isHidden = true
        
        
        //INITIALIZATIONS
        uidigitaltime.text = "\(self.defaults.string(forKey: "digital_time") ?? "") Min"
        
        toggleProgress(position: 0)
        
        uiplansegmentedControl.addTarget(self, action: #selector(uiplansegmentedControlValueChanged), for: .valueChanged)
        
        uistackview_main1.isHidden = false
        uistackview_main2.isHidden = false
        uistackview_requested.isHidden = true

    }
    
    @objc func uiplansegmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Get the selected segment index
        let selectedIndex = sender.selectedSegmentIndex
        toggleProgress(position: selectedIndex)
    }
    
    @objc func card_wallet_action(_ sender:UITapGestureRecognizer){
        logic_wallet()
    }
    
    @objc func card_mobile_action(_ sender:UITapGestureRecognizer){
        logic_mobile()
    }
    
    func logic_wallet(){
        card_mobile.layer.theme_borderColor = "inactive"
        card_wallet.layer.theme_borderColor = "active"
        self.pay_using = "dt"
    }
    func logic_mobile(){
        card_wallet.layer.theme_borderColor = "inactive"
        card_mobile.layer.theme_borderColor = "active"
        self.pay_using = "cash"
    }
    
    @IBOutlet weak var button_proceed: UIButton!
    
    
    @IBAction func action_proceed(_ sender: Any) {
        
        
        let station = self.ustation ?? ""
        let duration_str = self.udura ?? ""
        let payment_method = self.pay_using ?? ""
        let digital_time = self.defaults.string(forKey: "digital_time") ?? ""
        let email = self.defaults.string(forKey: "email") ?? ""
        let firstname = self.defaults.string(forKey: "firstname") ?? ""
        let surname = self.defaults.string(forKey: "surname") ?? ""
        let residence = self.defaults.string(forKey: "residence") ?? ""
        let phone_number = self.defaults.string(forKey: "phone_number") ?? ""
        
        if self.pay_using == "dt" {
            
            let time_current = Double( self.defaults.string(forKey: "digital_time") ?? "" )
            let duration = Double( self.tvduration ?? "" )
            
            if time_current ?? 0.0 >= duration ?? 0.0 {
                
                let dataOne : [String : String] = [
                    "phone_number": phone_number,
                    "duration": duration_str,
                    "payment_method":payment_method,
                    "email":email,
                    "amount":"0",
                    "surname":surname,
                    "firstname":firstname,
                    "residence":residence,
                    "station": station,
                    "digital_time": digital_time,
                    "type": "give",
                ]
                
                self.sendRequest(data : dataOne)
                
            }else{
                showPopUpMessageHelper(controller: self, title: "Ooops", message: "You do not have Digital Time to spend.")
            }
            
        }else if self.pay_using == "cash" {
            
            let dataOne : [String : String] = [
                "phone_number": phone_number,
                "duration": duration_str,
                "payment_method":payment_method,
                "email":email,
                "amount":tvprice ?? "",
                "surname":surname,
                "firstname":firstname,
                "residence":residence,
                "station": station,
                "digital_time": digital_time,
                "type": "give",
            ]
            
            self.sendRequest(data : dataOne)
        }
        
    }
    
    
    func sendRequest(data : [String : String]) {
        
        self.uiactivity.startAnimating()
        self.uiactivity.isHidden = false
        
        let db = Firestore.firestore()
        // Add the document to the "mukusers" collection with the phone number as the document ID
        db.collection("mukcurrentrequests").document(self.defaults.string(forKey: "phone_number") ?? "").setData(data) { error in
            if let error = error {
                // Handle the error
                print("Error adding document: \(error.localizedDescription)")
                showPopUpMessageHelper(controller: self, title: "Error", message: "Request failed to Save")
                
                self.uiactivity.stopAnimating()
                
                //self.btnRequestAgent.isHidden = false
                
                self.uistackview_main1.isHidden = true
                self.uistackview_main2.isHidden = true
                self.uistackview_requested.isHidden = false
                
            } else {
                // Document added successfully
                print("Request Document added successfully")
                self.setUpRegistrationListener()
                
                self.uiactivity.stopAnimating()
                
                self.uistackview_main1.isHidden = true
                self.uistackview_main2.isHidden = true
                self.uistackview_requested.isHidden = false
                
            }
        }
        
    }
    
    
    func setUpRegistrationListener(){
        let db = Firestore.firestore()

        // Get a reference to the document that you just created
        let docRef = db.collection("mukusers").document(self.defaults.string(forKey: "phone_number") ?? "")

        // Listen for changes to the "registration" field
        docRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            let has_rented = snapshot.data()?["has_rented"] as? String
            //print("Registration value changed to: \(registration ?? "nil")")
            
            if has_rented == "yes" {
                self.dismiss(animated: true)
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deleteRequestAgent()
    }
    
    func deleteRequestAgent(){
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        // Add the document to the "mukusers" collection with the phone number as the document ID
        db.collection("mukcurrentrequests").document(self.defaults.string(forKey: "phone_number") ?? "").delete() { error in
            if let error = error {
                // Handle the error
                print("Error adding document: \(error.localizedDescription)")
                showPopUpMessageHelper(controller: self, title: "Error", message: "Request failed to Save")
                //self.activity.stopAnimating()
                //self.btnRequestAgent.isHidden = false
            } else {
                // Document added successfully
                print("Request Document deleted successfully")
                //self.activity.stopAnimating()
                //self.btnRequestAgent.isHidden = false
            }
        }
        
    }
    

}
