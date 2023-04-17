//
//  DigitalTimePacksController.swift
//  Digital Bikes
//
//  Created by PSE on 17.04.23.
//

import UIKit
import Lottie

class DigitalTimePacksController: UIViewController {

    @IBOutlet weak var sliding_indicator: UIView!
    
    
    
    @IBOutlet weak var card_hour_glass: UIView!
    
    @IBOutlet weak var card_hour_glass_in: UIView!
    
    @IBOutlet weak var animation_hour_glass: LottieAnimationView!
    
    
    @IBOutlet weak var card_time_bucket: UIView!
    
    @IBOutlet weak var card_time_bucket_in: UIView!
    
    @IBOutlet weak var animation_time_bucket: LottieAnimationView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        
    }
    

    

}
