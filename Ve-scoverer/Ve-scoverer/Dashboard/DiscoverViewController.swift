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
import UserNotifications

class DiscoverViewController: UIViewController {
    //MARK: - Properties
    private let startingLocation = CLLocation(latitude: 37.773972, longitude: -122.431297)
    private let locationManager = CLLocationManager()
    private let radius: CLLocationDistance = 500
    private var annoationsArray = [MKPointAnnotation]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser?.email
    private var name = ""
    private var addedUsers = [String]()
    private var set: Set<String>?
    

    @IBOutlet weak private var nearbyUsers: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
   //addddddd tabbar badge which will connect to app badge!!!!!//////////-----------------------
     
        self.nearbyUsers.isRotateEnabled = false

        title = "Vescover"

        view.backgroundColor = UIColor(hexString: "8bcdcd")
        setStartingPosition()
        getLocations()
        UNUserNotificationCenter.current().delegate = self

        nearbyUsers.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        set = nil
        addedUsers = []

        
    }
    
   private func getLocations(){
        
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
    
    
    private func setStartingPosition(){
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
                            //I NEED TO MAKE SURE AN ALERT POPS  UP IF THEY RE ADD A USER 
                            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                                if let user = view.annotation?.title {
                                    
                                    
                                    
                                    
                                    self.db.collection("users").document(self.user!).collection("found").document(user!).setData(["latitude":Double((view.annotation?.coordinate.longitude)!), "longitude": Double((view.annotation?.coordinate.latitude)!), "email":user!])
             
                                    if let tabItems = self.tabBarController?.tabBar.items {
                                        // In this case we want to modify the badge number of the third tab:
                                        let tabItem = tabItems[3]
                                        self.addedUsers.append(user!)
                                        
                                        self.db.collection("users").document(self.user!).setData(["badge": "\(Set(self.addedUsers).count)"], merge: true)
                                        
                                        self.db.collection("users").document(self.user!).getDocument { (snapShot, err) in
                                            if let error = err {
                                                print(error.localizedDescription)
                                            } else {
                                                
                                                let data = snapShot?.data()
                                                
                                                let count = data?["badge"] as! String
                                                
                                                tabItem.badgeValue = count
                                                    


                                            }
                                        }
                 
                                        

                                        //self.added += 1
                                        
                                    }
                                  
                                    
                                    
                                }
                            }
                            
                            let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
                            alert.addAction(cancelAction)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true,completion: nil)

                            
                        }
                    }
                })
    
        }
 
    }
}

extension DiscoverViewController: UNUserNotificationCenterDelegate {
    
    
}
