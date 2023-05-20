//
//  SupportController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import Lottie
import UIKit

class SupportController: UIViewController {

    
    @IBOutlet weak var animation: LottieAnimationView!
    
    
    @IBOutlet weak var call_button: UIButton!
    
    @IBAction func call_action(_ sender: Any) {
        if let phoneUrl = URL(string: "tel://0775967096") {
            UIApplication.shared.open(phoneUrl)
        }
    }
    
    
    let fburl="https://www.facebook.com/digitalbikesint";
    let twiturl="https://twitter.com/digitalbikesint";
    let insturl="https://www.instagram.com/digitalbikesint/";
    
    
    @IBOutlet weak var feedback_button: UIButton!
    
    @IBAction func feedback_action(_ sender: Any) {
        if let url = URL(string: "mailto:samuelmugabi2@gmail.com?subject=DigitBikes&body=Hello") {
            UIApplication.shared.open(url)
        }

    }
    
    
    @IBOutlet weak var rate_button: UIButton!
    
    @IBAction func rate_action(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/us/app/digital-bikes/id6448875930") {
            UIApplication.shared.open(url)
        }
    }
    
    
    
    @IBOutlet weak var visit_our_website_button: UIButton!
    
    @IBAction func visit_our_website_action(_ sender: Any) {
        if let url = URL(string: "https://digitalbikesint.web.app") {
            UIApplication.shared.open(url)
        }

    }
    
    
    @IBOutlet weak var share_button: UIButton!
    
    @IBAction func share_action(_ sender: Any) {
        let message = "Download Digital Bikes to enjoy bicycle sharing. https://apps.apple.com/us/app/digital-bikes/id6448875930"
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        // Check if the device is iPad
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view // Set the source view to the view of the presenting view controller
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // Set the source rect to the center of the presenting view controller's view
            popoverPresentationController.permittedArrowDirections = [] // Remove the arrow direction
        }
        
        present(activityViewController, animated: true)

    }
    
   
    
    
    
    @IBOutlet weak var container_fb: UIView!
    
    @IBOutlet weak var container_insta: UIView!
    
    @IBOutlet weak var container_twitter: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 0.5
        animation.play()
        
        
        call_button.layer.cornerRadius = 10
        feedback_button.layer.cornerRadius = 10
        rate_button.layer.cornerRadius = 10
        visit_our_website_button.layer.cornerRadius = 10
        container_fb.layer.cornerRadius = 10
        container_insta.layer.cornerRadius = 10
        container_twitter.layer.cornerRadius = 10
        
        share_button.layer.cornerRadius = 10
    }
    

}
