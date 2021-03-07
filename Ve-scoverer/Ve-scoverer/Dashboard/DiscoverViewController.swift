//
//  DiscoverViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 05/11/2020.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import GoogleSignIn

class DiscoverViewController: UIViewController {
    //MARK: - Properties
    let startingLocation = CLLocation(latitude: 37.773972, longitude: -122.431297)
    private let locationManager = CLLocationManager()
    let radius: CLLocationDistance = 500
    var annoationsArray = [MKPointAnnotation]()
    let db = Firestore.firestore()
    var geoPoints = [GeoPoint]()
    let user = Auth.auth().currentUser?.email
    var name = ""

    @IBOutlet weak private var nearbyUsers: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nearbyUsers.isRotateEnabled = false

        title = "Vescover"

        view.backgroundColor = UIColor(hexString: "8bcdcd")
        setStartingPosition()
        getLocations()
        
        nearbyUsers.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func getLocations(){
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let latitude = data["latitude"] as! Double
                    let longitude = data["longitude"] as! Double
                    
                    let email = data["email"] as! String
                    
                    
                    
                    let annotation = MKPointAnnotation()
                    
                    if email != self.user {
                        annotation.title = (data["email"] as! String)
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.nearbyUsers.addAnnotation(annotation)
                        self.annoationsArray.append(annotation)
                        self.nearbyUsers.showAnnotations(self.annoationsArray, animated: true)

                    }
                
                    
                  
                    
                }
            }
        }
    }
    
    
    func setStartingPosition(){
        let position =  MKCoordinateRegion(center: startingLocation.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        nearbyUsers.setRegion(position, animated: true)
    }
}

//MARK: - CoreLocation Methods
extension DiscoverViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

//MARK: - MapKit Methods

extension DiscoverViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        DispatchQueue.main.async {
            let name = view.annotation!.title!

            self.db.collection("users").document(name!).getDocument(completion: { (snapShot, err) in
                    if let err = err {
                        print(err)
                    } else {
                        if let document = snapShot!.data() {
                            self.name = ((document["firstName"] as? String)!)
                            
                            let alert = UIAlertController(title: "Add \(self.name)", message: "", preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                                if let user = view.annotation?.title {
                                    
                                    self.db.collection("users").document(self.user!).collection("found").document(user!).setData(["latitude":Double((view.annotation?.coordinate.longitude)!), "longitude": Double((view.annotation?.coordinate.latitude)!), "email":user!
                                                                                                                                  
                                    ])
             
                                    if let tabItems = self.tabBarController?.tabBar.items {
                                        // In this case we want to modify the badge number of the third tab:
                                        let tabItem = tabItems[3]
                                        tabItem.badgeValue = "1"
                                    }
                                }
                            }
                            
                            let cancelAction = UIAlertAction(title: "Nvm", style: .cancel, handler: nil)
                            alert.addAction(cancelAction)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            alert.view.tintColor = UIColor(hexString: "3797A4")
                        }
                    }
                })
    
        }
 
    }
}
