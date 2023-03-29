//
//  AlertsHelper.swift
//  Prime Learn App
//
//  Created by PSE on 16.03.23.
//

import Foundation
import UIKit

public func createLoadingDialog(controller : UIViewController) -> UIAlertController{
    
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating()
    alert.view.addSubview(loadingIndicator)
    controller.present(alert, animated: true, completion: nil)
    
    return alert
}
