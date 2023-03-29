//
//  SupportController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import UIKit

class SupportController: UIViewController {

    @IBOutlet weak var call_button: UIButton!
    
    @IBAction func call_action(_ sender: Any) {
    }
    
    
    
    @IBOutlet weak var feedback_button: UIButton!
    
    @IBAction func feedback_action(_ sender: Any) {
    }
    
    
    @IBOutlet weak var rate_button: UIButton!
    
    @IBAction func rate_action(_ sender: Any) {
    }
    
    
    
    @IBOutlet weak var visit_our_website_button: UIButton!
    
    @IBAction func visit_our_website_action(_ sender: Any) {
    }
    
    
    @IBOutlet weak var share_button: UIButton!
    
    @IBAction func share_action(_ sender: Any) {
    }
    
   
    
    
    
    @IBOutlet weak var container_fb: UIView!
    
    @IBOutlet weak var container_insta: UIView!
    
    @IBOutlet weak var container_twitter: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
