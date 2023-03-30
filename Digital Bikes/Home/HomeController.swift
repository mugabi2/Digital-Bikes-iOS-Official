//
//  HomeController.swift
//  Digital Bikes
//
//  Created by PSE on 22.03.23.
//

import GoogleMaps
import UIKit
import MapKit
import FirebaseFirestore


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
        
        let location = CLLocationCoordinate2D(latitude: 0.332561, longitude: 32.569160)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        map_kit.setRegion(region, animated: true)
        
        //map_kit.centerCoordinate = location
        map_kit.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)


        getBikes()
        
        getInformation()
        
    }
    
    
    
    func getBikes(){
        let db = Firestore.firestore()
        let bikesRef = db.collection("mukbvs").document("bikes")

        bikesRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document exists, extract its data
                let data = document.data()
                // Do something with the data...
                
                print(data?["Africa"] as? String)
                
                let africa = DockingStation(name: "Africa", coordinate: CLLocationCoordinate2D(latitude: 0.337912, longitude: 32.568790),
                                            no_of_bikes: (data?["Africa"] as? String))
                let cedat = DockingStation(name: "CEDAT", coordinate: CLLocationCoordinate2D(latitude: 0.335882, longitude: 32.564807),
                                           no_of_bikes: (data?["CEDAT"] as? String) )
                let complex = DockingStation(name: "Complex", coordinate: CLLocationCoordinate2D(latitude: 0.329849, longitude: 32.570160),
                                             no_of_bikes: (data?["Complex"] as? String) )
                let swimmingpool = DockingStation(name: "Swimming Pool", coordinate: CLLocationCoordinate2D(latitude: 0.335345, longitude: 32.568673),
                                                  no_of_bikes: (data?["Swimming Pool"] as? String) )
                let library = DockingStation(name: "Library", coordinate: CLLocationCoordinate2D(latitude: 0.334936, longitude: 32.568000),
                                             no_of_bikes: (data?["Library"] as? String) )
                let livingstone = DockingStation(name: "Livingstone", coordinate: CLLocationCoordinate2D(latitude: 0.338686, longitude: 32.567718),
                                                 no_of_bikes: (data?["Livingstone"] as? String) )
                let marystuart = DockingStation(name: "Mary Stuart", coordinate: CLLocationCoordinate2D(latitude: 0.330985, longitude: 32.566668),
                                                no_of_bikes: (data?["Mary Stuart"] as? String) )
                let mitchell = DockingStation(name: "Mitchell", coordinate: CLLocationCoordinate2D(latitude: 0.333740, longitude: 32.570495),
                                              no_of_bikes: (data?["Mitchell"] as? String) )
                let uh = DockingStation(name: "University Hall", coordinate: CLLocationCoordinate2D(latitude: 0.332969, longitude: 32.572506),
                                        no_of_bikes: (data?["University Hall"] as? String) )

                let dockingStations = [africa, cedat, complex, swimmingpool, library, livingstone, marystuart, mitchell, uh]

                // Loop through the array and create an MKPointAnnotation object for each coordinate
                for dockingStation in dockingStations {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = dockingStation.coordinate
                    annotation.title = dockingStation.name
                    annotation.subtitle = "\(dockingStation.no_of_bikes ?? "0") Bikes"
                    self.map_kit.addAnnotation(annotation)
                }
                
                
            } else {
                // Document does not exist or there was an error
                print("Document does not exist or there was an error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func getInformation(){
        
    }

}

class DockingStation {
    let name: String
    let coordinate: CLLocationCoordinate2D
    let no_of_bikes: String?
    
    init(name: String, coordinate: CLLocationCoordinate2D, no_of_bikes: String?) {
        self.name = name
        self.coordinate = coordinate
        self.no_of_bikes = no_of_bikes
    }
}

class CustomAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Set the image property to your custom icon image
        self.image = UIImage(named: "marker")
        
        // Add subviews to the annotation view if needed
        //let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        //label.text = "Custom Label"
        //self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
