//
//  ProfileController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Lottie
import YPImagePicker

class ProfileController: UIViewController {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    
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
    
    @IBAction func delete_account_action(_ sender: Any) {
        
        // Create the alert controller
        let alertController = UIAlertController(
            title: "Delete Account?",
            message: "This action cannot be undone, because all your information shall be removed from our servers. Are you sure you want to delete your account?",
            preferredStyle: .alert)

        // Create the actions
        let action1 = UIAlertAction(title: "Delete Account", style: .destructive) { _ in
            // Handle action 1
            
            do{
                try Auth.auth().signOut()
            }catch{}
            self.dismiss(animated: true)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        // Add the actions to the alert controller
        alertController.addAction(action1)
        alertController.addAction(cancelAction)

        // Present the alert controller
        self.present(alertController, animated: true)

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
        
        profile_edit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profile_edit_action(_:))))
        
        listenToUserInformationChange()
    }
    
    func listenToUserInformationChange(){
        let db = Firestore.firestore()

        // Get a reference to the document that you just created
        let docRef = db.collection("mukusers").document(self.defaults.string(forKey: "phone_number") ?? "")

        // Listen for changes to the "registration" field
        docRef.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            //let registration = snapshot.data()?["registration"] as? String
            print("Information changed")
            
            //self.dismiss(animated: true)
            if let userData = snapshot.data() {
                updateUserDefaultsInfo(userData: userData)
            }
            
            self.displayUser()
        }
    }
    
    
    @objc func buy_card_action(_ sender:UITapGestureRecognizer){
        if let vc = UIStoryboard(name: "DigitalTimePacks", bundle: nil).instantiateInitialViewController() {
            
            present(vc, animated: true)
            
        }
    }
    
    @objc func profile_edit_action(_ sender:UITapGestureRecognizer){
        var config = YPImagePickerConfiguration()
        config.onlySquareImagesFromCamera = true
        config.showsCrop = .circle
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                var compressedImage = self.compressImage(image: photo.image, compressionQuality: 0.5)
                self.profile_picture.image = compressedImage
                
                //
                if let image = compressedImage {
                    if let imageData = image.pngData() {
                        let base64String = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                        // use base64String as needed
                        self.defaults.setValue(base64String, forKey: "profile_picture")
                    }
                    self.uploadImage( image : image )
                }
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    func uploadImage( image : UIImage ){
        
        
        let storageRef = Storage.storage().reference().child("userProfilePhotos/\(defaults.string(forKey: "phone_number") ?? "" )")
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Upload failed:", error?.localizedDescription ?? "Unknown error")
                    return
                }
                print( metadata.path )
                print("Upload succeeded:", "No URL")
            }
            
            uploadTask.observe(.progress) { snapshot in
                guard let progress = snapshot.progress else { return }
                let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                let percentString = String(format: "%.0f%%", percentComplete * 100)
                print("Upload progress:", percentString)
            }
            
            uploadTask.observe(.success) { snapshot in
                print("Upload completed successfully")
            }
            
            uploadTask.observe(.failure) { snapshot in
                if let error = snapshot.error {
                    print("Upload failed:", error.localizedDescription)
                }
            }
        }
        
    }

    func compressImage(image: UIImage?, compressionQuality: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else { return nil }
        return UIImage(data: imageData)
    }
    
    
    
    func ConvertBase64StringToImage(imageBase64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: imageBase64String, options: .init(rawValue: 0)) else {
            return nil
        }
        let image = UIImage(data: imageData)
        return image
    }

    
    @IBOutlet weak var uiPhoneNumber: UILabel!
    
    let defaults = UserDefaults.standard
    
    func displayUser(){
        
        uiPhoneNumber.text = defaults.string(forKey: "phone_number")
        name.text = "\(defaults.string(forKey: "firstname") ?? "") \(defaults.string(forKey: "surname") ?? "")".trimmingCharacters(in: .whitespaces)
        email.text = defaults.string(forKey: "email")
        residence_text.text = defaults.string(forKey: "residence")
        digital_time_text.text = defaults.string(forKey: "digital_time")
        location_text.text = defaults.string(forKey: "preferred_location")
        
        if let profile_picture = defaults.string(forKey: "profile_picture") {
            if profile_picture.isEmpty == false {
                //self.profile_picture.image = ConvertBase64StringToImage(imageBase64String: profile_picture)
            }
        }
        
        //GET UPLOADED IMAGE
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("userProfilePhotos/\(defaults.string(forKey: "phone_number") ?? "" )")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                if let image = UIImage(data: data!){
                    self.profile_picture.setImage(image)
                }else{
                    print( "Image Has Issues" )
                }
            }
        }
        
        
    }

}
