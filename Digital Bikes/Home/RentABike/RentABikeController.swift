//
//  RentABikeController.swift
//  Digital Bikes
//
//  Created by PSE on 16.04.23.
//

import UIKit
import SwiftTheme

class RentABikeController: UIViewController {
    
    @IBOutlet weak var card_mobile: UIView!
    
    @IBOutlet weak var card_wallet: UIView!
    
    @IBAction func action_cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var slide_down_indicator: UIView!
    
    
    
    var pay_using = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.pay_using = "wallet"
    }
    func logic_mobile(){
        card_wallet.layer.theme_borderColor = "inactive"
        card_mobile.layer.theme_borderColor = "active"
        self.pay_using = "cash"
    }
    
    @IBOutlet weak var button_proceed: UIButton!
    
    
    @IBAction func action_proceed(_ sender: Any) {
    }
    

}
