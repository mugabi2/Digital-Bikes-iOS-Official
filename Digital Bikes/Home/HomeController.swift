//
//  HomeController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import GoogleMaps
import UIKit
import MapKit


class HomeController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var caution_card: UIView!
    
    @IBOutlet weak var caution_text: UILabel!
    
    @IBOutlet weak var info_card: UIView!
    
    @IBOutlet weak var map_kit: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caution_card.layer.cornerRadius = 10.0
        info_card.layer.cornerRadius = 10.0
        
       
        map_kit.delegate = self
        
        let location = CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186)
        map_kit.centerCoordinate = location
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Apple Park"
        annotation.subtitle = "Cupertino, CA"
        map_kit.addAnnotation(annotation)


        
    }


}
