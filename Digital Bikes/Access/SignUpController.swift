//
//  SignUpController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import UIKit
import DropDown
import FlagPhoneNumber
import FirebaseAuth
import FirebaseFirestore

class SignUpController: UIViewController {

    @IBOutlet weak var bg: UIView!
    
    @IBOutlet weak var sname: UITextField!
    
    @IBOutlet weak var phone: FPNTextField!
    
    @IBOutlet weak var fname: UITextField!
    
    @IBOutlet weak var residence: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var switchPP: UISwitch!
    
    @IBOutlet weak var swtichTC: UISwitch!
    
    
    
    
    
    @IBOutlet weak var sign_up_button: UIButton!
    
    @IBAction func sign_up_action(_ sender: Any) {
        
        if !switchPP.isOn {
            showPopUpMessageHelper(controller: self, title: "Privacy Policy", message: "Please read the Privacy Policy.")
            return
        }
        
        if !swtichTC.isOn {
            showPopUpMessageHelper(controller: self, title: "Terms and Conditions", message: "Please read the Terms and Conditions.")
            return
        }
        
        
        if gender == nil {
            showPopUpMessageHelper(controller: self, title: "Gender", message: "Please Select your Gender")
            return
        }
        
        if let phoneNumber = phone.getFormattedPhoneNumber(format: .E164){
             
            if ( phoneNumber == "+(null)(null)") {
                showPopUpMessageHelper(controller: self, title: "Phone Number", message: "Enter a valid Phone Number")
            }else{
                Auth.auth().createUser(withEmail: email.text ?? "", password: password.text ?? "")
                    { [weak self] authResult, error in
                        guard let strongSelf = self else { return }
                        
                        // Get a reference to the Firestore database
                        let db = Firestore.firestore()
                        
                        // Define the data to be saved
                        let today = strongSelf.getCurrentDate()
                        let dataOne : [String : String] = [
                            "firstname": strongSelf.fname.text ?? "",
                            "surname": strongSelf.sname.text ?? "",
                            "phone_number": phoneNumber,
                            "email": strongSelf.email.text ?? "",
                            "fine_status": "0",
                            "bicycle_out": "0",
                            "agent_name": "",
                            "agent_code": "",
                            "bicycle_number": "0",
                            "helmet": "0",
                            "suspension": "0",
                            // "password": psword,
                            "residence": strongSelf.residence.text ?? "",
                            "digital_time": "20",
                            "duration": "20 mins",
                            "registration": "0",
                            "renting_times": "0",
                            "has_rented": "no",
                            "log_in_times": "1",
                            "free_digital_time": "0",
                            "share_coded": "0",
                            "preferred_location": "MUK",
                            "earining": "0",
                            "gender": strongSelf.gender ?? "",
                            "date_of_joining": today ?? "",
                            "registered_by": "0",
                            "fine_times": "0",
                            "password_recovery": "0",
                            "recovery_code": "0",
                            "time_riding": "00:00",
                            "stars": "5",
                            "comment": "five star",
                            "app_opens": "1",
                            "profilePhoto": "0",
                            "profilePhotoUrl": "gs://quiz-fox.appspot.com/USERS/default.jpg"
                        ]
                        
                        // Add the document to the "mukusers" collection with the phone number as the document ID
                        db.collection("mukusers").document(phoneNumber).setData(dataOne) { error in
                            if let error = error {
                                // Handle the error
                                print("Error adding document: \(error.localizedDescription)")
                                showPopUpMessageHelper(controller: strongSelf, title: "Error", message: "Data failed to Save")
                            } else {
                                // Document added successfully
                                print("Document added successfully")
                                strongSelf.getTheUserFromAuth()
                            }
                        }
                        
                        
                        
                    }
                
                
                
                
            }
            
        }else{
                showPopUpMessageHelper(controller: self, title: "Phone Number", message: "Enter valid Phone Number.")
        }
    
        
    }
    
    func getCurrentDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "ddMMMyyyyHHmmss"
        dateFormat.timeZone = TimeZone(identifier: "EAT")
        let today = Date()
        return dateFormat.string(from: today)
    }
    
    @IBAction func readPP(_ sender: Any) {
        openURL("https://digitalbikesint.web.app/privacy_policy.html")
    }
    
    @IBAction func readTC(_ sender: Any) {
        openURL("https://digitalbikesint.web.app/terms_and_conditions.html")
    }
    
    
    @IBOutlet weak var gender_button: UIButton!
    
    @IBAction func gender_action(_ sender: UIButton) {
                let dropDown = DropDown()
                dropDown.anchorView = sender
                dropDown.dataSource = ["Male", "Female"]
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    sender.setTitle("Gender: \(item)", for: .normal)
                    self.gender = String(item.prefix(1))
                }
                dropDown.width = sender.bounds.width
                dropDown.show()
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gender_button.layer.cornerRadius = 10
        sign_up_button.layer.cornerRadius = 10
        bg.layer.cornerRadius = 10

        title = "Sign Up"
    
    }
    
    
    
    var gender : String? = nil
    
    
    //DUPLICATE FROM HOME SCREEN
    
    func getTheUserFromAuth(){
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
            
            self.saveDetails(email:email ?? "")
            
            
        } else {
          // No user is signed in.
          // ...
        }
    }
    
    func saveDetails(email : String){
        
        let defaults = UserDefaults.standard
        saveUserValuesToDefaults(email: email , defaults: defaults)
        
    }
    
    func saveUserValuesToDefaults(email: String, defaults: UserDefaults) {
        
        let db = Firestore.firestore()
        
        // Access the "mukusers" collection and retrieve the document where the email matches the one provided
        db.collection("mukusers").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                // Handle any errors that occur
                print("Error: \(error.localizedDescription)")
            } else {
                // Check if any documents were found
                guard let document = querySnapshot?.documents.first else {
                    print("No user found with that email")
                    return
                }
                
                // Save the specified values of the document to UserDefaults
                let userData = document.data()
                defaults.set(userData["firstname"], forKey: "firstname")
                defaults.set(userData["surname"], forKey: "surname")
                defaults.set(userData["phone_number"], forKey: "phone_number")
                defaults.set(userData["email"], forKey: "email")
                defaults.set(userData["agent_name"], forKey: "agent_name")
                defaults.set(userData["agent_code"], forKey: "agent_code")
                defaults.set(userData["fine_status"], forKey: "fine_status")
                defaults.set(userData["bicycle_out"], forKey: "bicycle_out")
                defaults.set(userData["bicycle_number"], forKey: "bicycle_number")
                defaults.set(userData["helmet"], forKey: "helmet")
                defaults.set(userData["suspension"], forKey: "suspension")
                defaults.set(userData["residence"], forKey: "residence")
                defaults.set(userData["digital_time"], forKey: "digital_time")
                defaults.set(userData["registration"], forKey: "registration")
                defaults.set(userData["renting_times"], forKey: "renting_times")
                defaults.set(userData["free_digital_time"], forKey: "free_digital_time")
                defaults.set(userData["share_coded"], forKey: "share_coded")
                defaults.set(userData["preferred_location"], forKey: "preferred_location")
                defaults.set(userData["earning"], forKey: "earning")
                defaults.set(userData["gender"], forKey: "gender")
                defaults.set(userData["date_of_joining"], forKey: "date_of_joining")
                defaults.set(userData["registered_by"], forKey: "registered_by")
                defaults.set(userData["fine_times"], forKey: "fine_times")
                defaults.set(userData["password_recovery"], forKey: "password_recovery")
                defaults.set(userData["recovery_code"], forKey: "recovery_code")
                defaults.set(userData["time_riding"], forKey: "time_riding")
                defaults.set(userData["stars"], forKey: "stars")
                defaults.set(userData["comment"], forKey: "comment")
                defaults.set(userData["app_opens"], forKey: "app_opens")
                defaults.set(userData["profile_photo"], forKey: "profile_photo")
                defaults.set(userData["profile_photo_url"], forKey: "profile_photo_url")
                
                // Synchronize UserDefaults to make sure the values are saved
                defaults.synchronize()
                
                self.goToHome()
                
                print("User values saved to UserDefaults")
            }
        }
    }

    func goToHome(){
        if let home = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() {
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true)
        }
    }
}



func showPopUpMessageHelper(controller:UIViewController?, title: String?, message: String?, button: String? = "OK"){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: button, style: .default, handler: nil) )
    controller?.present(alert, animated: true, completion: nil)
}
