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
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.title = (data["email"] as! String)
                
                    
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.nearbyUsers.addAnnotation(annotation)
                    self.annoationsArray.append(annotation)
                    self.nearbyUsers.showAnnotations(self.annoationsArray, animated: true)
                    
                }
            }
        }
    }
    
    func setAnnotation(geoPoint:[GeoPoint]){
        
        for point in geoPoint {
            let annotation = MKPointAnnotation()
            //annotation.title = store.name
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            nearbyUsers.addAnnotation(annotation)
            annoationsArray.append(annotation)
            nearbyUsers.showAnnotations(annoationsArray, animated: true)
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
        
        let insertion = MKPointAnnotation()
        insertion.coordinate.longitude = (locations.last?.coordinate.longitude)!
        insertion.coordinate.latitude = (locations.last?.coordinate.latitude)!
        annoationsArray.append(insertion)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

//MARK: - MapKit Methods

extension DiscoverViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let alert = UIAlertController(title: "View User", message: "", preferredStyle: .alert)
        
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
        present(alert, animated: true, completion: nil)
      
    }
}
