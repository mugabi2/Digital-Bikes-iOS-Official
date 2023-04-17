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
import FirebaseStorage
import Agrume

class HomeController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var caution_card: UIView!
    
    @IBOutlet weak var caution_text: UILabel!
    
    @IBOutlet weak var info_card: UIView!
    
    @IBOutlet weak var map_kit: MKMapView!
    
    
    var posters = [QueryDocumentSnapshot]()
    var postersUIImages = [Int : UIImage]()
    @IBOutlet weak var posterCollectionView: UICollectionView!
    var posterReuse = "PosterViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caution_card.layer.cornerRadius = 10.0
        info_card.layer.cornerRadius = 10.0
        
        posterCollectionView.delegate = self
        posterCollectionView.dataSource = self
        posterCollectionView.register(UINib(nibName: posterReuse, bundle: nil), forCellWithReuseIdentifier: posterReuse)

        
       
        map_kit.delegate = self
        
        let location = CLLocationCoordinate2D(latitude: 0.332561, longitude: 32.569160)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        map_kit.setRegion(region, animated: true)
        
        //map_kit.centerCoordinate = location
        //map_kit.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)


        getBikes()
        
        getInformation()
        
        getPromotions()
    }
    
    func getPromotions(){
        
        let db = Firestore.firestore()
        db.collection("promotions")
            .getDocuments { snapshot, error in
                print("HAPPENING \( snapshot?.count)")
                if snapshot != nil {
                    self.posters = snapshot!.documents
                    self.posterCollectionView.reloadData()
                }else{
                }
            }
        
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
                    let number_of_bikes_at_station = dockingStation.no_of_bikes ?? "0"
                    
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = dockingStation.coordinate
                        annotation.title = dockingStation.name
                        annotation.subtitle = "\(number_of_bikes_at_station) Bikes"
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let annotation = view.annotation {
                // Handle the callout click here
                print("Callout clicked: \(annotation.title ?? "")")
                
                if let vc = UIStoryboard(name: "RentABike", bundle: .main).instantiateInitialViewController() {
                    present(vc, animated: true)
                }
                
            }
        }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
           if let annotation = view.annotation {
               // Handle the annotation click here
               print("Annotation clicked: \(annotation.title ?? "")")
           }
       }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          if annotation is MKUserLocation {
              // Return nil to use default view for user location annotation
              return nil
          }
          
                let identifier: String
                var annotationView: MKAnnotationView?
                
        
                print( annotation.subtitle!! )
                if ( annotation.subtitle!! != "0 Bikes" ) {
                    identifier = "HasBikesAnnotationView"
                    annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? HasBikesAnnotationView
                    if annotationView == nil {
                        annotationView = HasBikesAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    }
                    // Customize the appearance of the restaurant annotation view
                    //annotationView?.image = UIImage(named: "restaurant-icon")
                } else {
                    identifier = "NoBikesAnnotationView"
                    annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? NoBikesAnnotationView
                    if annotationView == nil {
                        annotationView = NoBikesAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    }
                    // Customize the appearance of the museum annotation view
                    //annotationView?.image = UIImage(named: "museum-icon")
                }
                
        
        
        
        
        
        
        
          annotationView?.canShowCallout = true
        
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
            
          //annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
          //annotationView?.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
          return annotationView
      }

}


extension HomeController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let img = self.postersUIImages[indexPath.row] {
            let agrume = Agrume(image: img)
            agrume.show(from: self)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: posterReuse, for: indexPath) as! PosterViewCell
        
        let imageurl = posters[indexPath.row].get("imageurl") as! String?
        let storage = Storage.storage()
        let storageRef = storage.reference().child( imageurl! )
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] data, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    } else {
                        if let imageData = data {
                            // Set the image data as the image of the image view
                            if let img = UIImage(data: imageData) {
                                self.postersUIImages[indexPath.row] = img
                                cell.picture.image = img
                            }
                        }
                    }
                }
        
        return cell
        
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

class HasBikesAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Set the image property to your custom icon image
        self.image = UIImage(named: "marko")
        
        // Add subviews to the annotation view if needed
        //let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        //label.text = "Custom Label"
        //self.addSubview(label)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NoBikesAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Set the image property to your custom icon image
        self.image = UIImage(named: "markrr")
        
        // Add subviews to the annotation view if needed
        //let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        //label.text = "Custom Label"
        //self.addSubview(label)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

