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


        
        getInformation()
        
        getPromotions()
        
        setUpUserListener()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getBikes()
        
        refreshUserInforamtion()
        
    }
    
    
    func setUpUserListener(){
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
            //print("Registration value changed to: \(registration ?? "nil")")
            
            if let data = snapshot.data() {
                self.updateUserDefaults(userData: data)
            }
            
        }
    }
        
    
    //REFRESH INFORMATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    func refreshUserInforamtion(){
    
        let db = Firestore.firestore()
        let email = defaults.string(forKey: "email") ?? ""
        db.collection("mukusers").whereField("email", isEqualTo: email ).getDocuments() { (querySnapshot, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("No user found with that email")
                    return
                }
                
                let userData = document.data()
                self.updateUserDefaults(userData: userData)
                
                //self.registration = userData["registration"] as! String?
                self.digital_time = userData["digital_time"] as! String?
                self.has_rented = userData["has_rented"] as! String?
                self.time_returned = userData["time_returned"] as! String?
                self.time_taken = userData["time_taken"] as! String?
                
                if self.has_rented  == "yes" {
                    
                    self.transaction_id = userData["transaction_id"] as! String?
                    self.bike_number = userData["bike_number"] as! String?
                    self.start = userData["start"] as! String?
                    self.end = userData["end"] as! String?
                    self.pin = userData["pin"] as! String?
                    
                    //SHOW RETURN BIKE SCREEN
                    showPopUpMessageHelper(controller: self, title: nil, message: "RETURN BIKE")
                    
                }else{
                    
                    //IS Free to RENT
                    //showPopUpMessageHelper(controller: self, title: nil, message: "FREE TO RENT")
                }
                
                
                print("User Data Updated")
            }
        }
        
    }
    
    //PERSON INFO UPDATE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let defaults = UserDefaults.standard
    var has_rented : String? = nil
    var digital_time : String? = nil
    var time_returned : String? = nil
    var time_taken : String? = nil
    var transaction_id : String? = nil
    var bike_number : String? = nil
    var start : String? = nil
    var end : String? = nil
    var pin : String? = nil
    var ustation : String? = nil
    
    func updateUserDefaults(userData : [String : Any] ){
        defaults.set(userData["firstname"], forKey: "firstname")
        defaults.set(userData["surname"], forKey: "surname")
        defaults.set(userData["phone_number"], forKey: "phone_number")
        defaults.set(userData["email"], forKey: "email")
        defaults.set(userData["agent_name"], forKey: "agent_name")
        defaults.set(userData["agent_code"], forKey: "agent_code")
        defaults.set(userData["fine_status"], forKey: "fine_status")
        defaults.set(userData["bicycle_out"], forKey: "bicycle_out")
        defaults.set(userData["bicycle_number"], forKey: "bicycle_number")
        defaults.set(userData["helmet"], forKey: "helmet")
        defaults.set(userData["suspension"], forKey: "suspension")
        defaults.set(userData["residence"], forKey: "residence")
        defaults.set(userData["digital_time"], forKey: "digital_time")
        defaults.set(userData["registration"], forKey: "registration")
        defaults.set(userData["renting_times"], forKey: "renting_times")
        defaults.set(userData["free_digital_time"], forKey: "free_digital_time")
        defaults.set(userData["share_coded"], forKey: "share_coded")
        defaults.set(userData["preferred_location"], forKey: "preferred_location")
        defaults.set(userData["earning"], forKey: "earning")
        defaults.set(userData["gender"], forKey: "gender")
        defaults.set(userData["date_of_joining"], forKey: "date_of_joining")
        defaults.set(userData["registered_by"], forKey: "registered_by")
        defaults.set(userData["fine_times"], forKey: "fine_times")
        defaults.set(userData["password_recovery"], forKey: "password_recovery")
        defaults.set(userData["recovery_code"], forKey: "recovery_code")
        defaults.set(userData["time_riding"], forKey: "time_riding")
        defaults.set(userData["stars"], forKey: "stars")
        defaults.set(userData["comment"], forKey: "comment")
        defaults.set(userData["app_opens"], forKey: "app_opens")
        defaults.set(userData["profile_photo"], forKey: "profile_photo")
        defaults.set(userData["profile_photo_url"], forKey: "profile_photo_url")
        
        // Synchronize UserDefaults to make sure the values are saved
        defaults.synchronize()
    }
    
    
    //PERSON ALREADY RENTED >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    //PERSON CAN RENT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
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
                
                let annotationTitle = annotation.title ?? ""
                let annotationSubTitle = annotation.subtitle ?? ""
                
                print("Callout clicked: \(annotationTitle)")
                print("Callout clicked: \(annotationSubTitle)")
                
                
                if self.has_rented  == "yes" {
                    
                    //SHOW RETURN BIKE SCREEN
                    showPopUpMessageHelper(controller: self, title: "\(annotation.title ?? "")", message: "RETURN BIKE")
                    
                }else{
                    
                    //if there is a bike
                    let numberOfBikes = annotationSubTitle?.replacingOccurrences(of: " Bikes", with: "").trimmingCharacters(in: .whitespaces)
                    print( "BikesNow:\( numberOfBikes ?? "" )")
                    
                    if (numberOfBikes != "0"){
                        
                        self.ustation = annotationTitle;
                        //ustationcode="1";
                        
                        if( self.defaults.string(forKey: "registration") != "0" ){
                            //already registered
                            if let vc = UIStoryboard(name: "RentABike", bundle: .main).instantiateInitialViewController() {
                                let controller = vc as! RentABikeController
                                controller.ustation = annotationTitle
                                present(controller, animated: true)
                            }
                        } else {
                            //register user
                            if let vc = UIStoryboard(name: "FinalRegistration", bundle: .main).instantiateInitialViewController() {
                                let controller = vc as! FinalRegistrationController
                                controller.ustation = annotationTitle
                                present(controller, animated: true)
                            }
                        }
                        
                    }else{
                        //no bike
                        showPopUpMessageHelper(controller: self, title: "\(annotation.title ?? "")", message: "There is no Bike on this Station")
                    }
                    
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
                    // annotationView?.image = UIImage(named: "restaurant-icon")
                } else {
                    identifier = "NoBikesAnnotationView"
                    annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? NoBikesAnnotationView
                    if annotationView == nil {
                        annotationView = NoBikesAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    }
                    // Customize the appearance of the museum annotation view
                    // annotationView?.image = UIImage(named: "museum-icon")
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

