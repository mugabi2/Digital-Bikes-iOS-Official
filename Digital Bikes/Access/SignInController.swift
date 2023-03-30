//
//  SignInController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignInController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bg.layer.cornerRadius = 10
        login_button.layer.cornerRadius = 10
        
        self.getTheUserFromAuth()
        
    }
    
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
    
    
    @IBOutlet weak var login_button: UIButton!
    
    @IBAction func login_action(_ sender: Any) {
        
        if email.text?.isEmpty == true {
            let alert = UIAlertController(title: "Caution", message: "Please enter email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil) )
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if password.text?.isEmpty == true {
            let alert = UIAlertController(title: "Caution", message: "Please enter password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil) )
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: email.text ?? "", password: password.text ?? "")
        { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            self?.getTheUserFromAuth()
        }
        
        
    }
    
    
    @IBOutlet weak var register_button: UIButton!
    
    @IBAction func register_action(_ sender: Any) {
        if let home = UIStoryboard(name: "SignUp", bundle: nil).instantiateInitialViewController() {
            //home.modalPresentationStyle = .fullScreen
            //present(home, animated: true)
            self.navigationController?.pushViewController(home, animated: true)
        }
    }
    
    
    @IBOutlet weak var bg: UIView!
    
    
}
