//
//  FinalRegistrationController.swift
//  Digital Bikes
//
//  Created by PSE on 13.05.23.
//

import UIKit
import FirebaseFirestore

class FinalRegistrationController: UIViewController {

    let defaults = UserDefaults.standard
    var ustation : String? = nil
    
    @IBOutlet weak var sliderIndicator: UIView!
    
    @IBOutlet weak var btnRequestAgent: UIButton!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    @IBAction func buttonRequestAgent(_ sender: UIButton) {
        activity.startAnimating()
        activity.isHidden = false
        btnRequestAgent.isHidden = true
        
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        // Add the document to the "mukusers" collection with the phone number as the document ID
        db.collection("mukcurrentrequests").document(self.defaults.string(forKey: "phone_number") ?? "").setData(dataOne) { error in
            if let error = error {
                // Handle the error
                print("Error adding document: \(error.localizedDescription)")
                showPopUpMessageHelper(controller: self, title: "Error", message: "Request failed to Save")
                self.activity.stopAnimating()
                self.btnRequestAgent.isHidden = false
            } else {
                // Document added successfully
                print("Request Document added successfully")
                //self.activity.stopAnimating()

                self.setUpRegistrationListener()
            }
        }
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
                self.activity.stopAnimating()
                self.btnRequestAgent.isHidden = false
            } else {
                // Document added successfully
                print("Request Document deleted successfully")
                self.activity.stopAnimating()
                self.btnRequestAgent.isHidden = false
            }
        }
        
    }
    
    var dataOne : [String : String] = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataOne = [
            "phone_number": self.defaults.string(forKey: "phone_number") ?? "",
            "duration": "register",
            "payment_method":"",
            "email":self.defaults.string(forKey: "email") ?? "",
            "amount":"",
            "surname":self.defaults.string(forKey: "surname") ?? "",
            "firstname":self.defaults.string(forKey: "firstname") ?? "",
            "residence":self.defaults.string(forKey: "residence") ?? "",
            "station": ustation ?? "",
            "digital_time": self.defaults.string(forKey: "digital_time") ?? "",
            "type": "register",
        ]
        
        //check if there is a request
        //remove it
        
        //send request
        //listen if registered
        setUpRegistrationListener()
        
        initializeViews()
        
        btnRequestAgent.layer.cornerRadius = btnRequestAgent.bounds.height/2
        sliderIndicator.layer.cornerRadius = sliderIndicator.bounds.height/2
        
        deleteRequestAgent()
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
            
            let registration = snapshot.data()?["registration"] as? String
            print("Registration value changed to: \(registration ?? "nil")")
            
            //self.dismiss(animated: true)
            
            if registration == "1" {
                
                let alertController = UIAlertController(title: "Registration Successful", message: "You can now proceed to get a bike", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.defaults.set(registration ?? "", forKey: "registration")
                    self.dismiss(animated: true)
                    self.deleteRequestAgent()
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)

            }
        }
    }
    
    func initializeViews(){
        activity.stopAnimating()
    }
    

}
