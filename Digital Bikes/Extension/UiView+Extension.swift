//
//  UiView+Extension.swift
//  Prime Learn App
//
//  Created by PSE on 17.01.23.
//

import Foundation
import UIKit
import SwiftTheme

extension UIView {
        
    func makeButton(){
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height/2
        giveShadow()
    }
    
    func giveRounds(){
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
        giveShadow()
    }
    func giveCorners(){
        layer.masksToBounds = true
        layer.cornerRadius = 10.0
    }
    func giveCircle(){
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height/2
    }
    func giveShadow(){
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.4
    }
    
    func makeViewSelected(isSelected:Bool){
        if( isSelected ){
            theme_backgroundColor = "active"
        }else{
            theme_backgroundColor = "inactive"
        }
    }
    
}

extension UILabel {
    func makeTextSelected(isSelected:Bool){
        if( isSelected ){
            theme_textColor = "text_white"
        }else{
            theme_textColor = "text_black"
        }
    }
}

