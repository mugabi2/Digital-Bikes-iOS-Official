//
//  ReturnABikeController.swift
//  Digital Bikes
//
//  Created by PSE on 20.05.23.
//

import UIKit
import FirebaseFirestore

class ReturnABikeController: UIViewController {

    @IBOutlet weak var slide_indicator: UIView!
    
    @IBOutlet weak var bike_name: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var time_start: UILabel!
    
    @IBOutlet weak var time_end: UILabel!
    
    @IBOutlet weak var card_start: UIView!
    
    @IBOutlet weak var card_end: UIView!
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        card_end.layer.cornerRadius = 20
        card_start.layer.cornerRadius = 20
        slide_indicator.layer.cornerRadius = 5
        
        self.setUpRegistrationListener()
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
            if has_rented == "yes" {
                
                let bike_number = snapshot.data()?["bike_number"] as? String
                let start = snapshot.data()?["start"] as? String
                let end = snapshot.data()?["end"] as? String
                let duration = snapshot.data()?["duration"] as? String
                
                self.time_start.text = start
                self.time_end.text = end
                self.bike_name.text = bike_number
                self.duration.text = duration
                
            } else {
                self.dismiss(animated: true)
            }
            
            
            
            
            
            //print("Registration value changed to: \(registration ?? "nil")")
            
            //self.dismiss(animated: true)
            
        }
    }
    
}
