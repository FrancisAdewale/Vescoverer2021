//
//  LoginViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 04/11/2020.
//

import UIKit
import Firebase
import CoreLocation
import CoreData
import AuthenticationServices
import GoogleSignIn


class LoginViewController: UIViewController, CLLocationManagerDelegate, GIDSignInDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate)
    
    
    let db = Firestore.firestore()
    let btnAuthorization = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
    var location = CLLocation()
    private let locationManager = CLLocationManager()
    var firstName = ""
    var secondName = ""
    var emailId = ""
    let user = Auth.auth().currentUser
    var userlocation = CLLocationCoordinate2D()
    var hasCompletedRegistration: Bool?
    
    
    
    //    @IBOutlet weak var loginLabel: UIButton!
    //    @IBOutlet weak var registerLabel: UIBarButtonItem!
    //    @IBOutlet weak var registerBar: UIToolbar!
    //    @IBOutlet weak var emailTextField: UITextField!
    //    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.modalPresentationStyle = .fullScreen
        view.backgroundColor = UIColor(hexString: "3797A4")
        navigationItem.hidesBackButton = true
        
        let docRef = db.collection("users").document((user?.email)!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                self.hasCompletedRegistration = (dataDescription?["completedRegistration"] as! Bool)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSOAppleSignIn()
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.startUpdatingLocation()
        }
        
        // Automatically sign in the user.
        //        hideKeyboardWhenTappedAround()
    }
    

    func setupSOAppleSignIn() {
        
        btnAuthorization.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        btnAuthorization.center = self.view.center
        
        btnAuthorization.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        
        self.view.addSubview(btnAuthorization)
        
    }
    
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email,]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
               if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                   print("The user has not signed in before or they have since signed out.")
               } else {
                   print("\(error.localizedDescription)")
               }
               return
           }
           
            
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                              accessToken: authentication.accessToken)

 
            
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if self.hasCompletedRegistration == nil {
                
                Auth.auth().signIn(with: credential) {(authResult, error) in
                    if let error = error {
                        print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                    } else  {
                        let user = user.profile
                        self.firstName = (user?.givenName)!
                        self.secondName = (user?.familyName)!
                        self.emailId = (self.user?.email)!
                        self.userlocation = self.location.coordinate
                        
                        self.db.collection("users").document((self.user?.email)!).setData([
                            "email": self.emailId,
                            "firstName": self.firstName,
                            "secondName": self.secondName,
                            "longitude": Double(self.userlocation.longitude),
                            "latitude": Double(self.userlocation.latitude),
                            "completedRegistration": false
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
                                
                                print("Document successfully written!")
                            }
                        }
                        
                    }
                    let vVc = storyboard.instantiateViewController(withIdentifier: "Vegan") as! VeganViewController
                    vVc.modalPresentationStyle = .overFullScreen
                    self.present(vVc, animated: false, completion: nil)
                }
                
            } else if self.hasCompletedRegistration! == true {
                Auth.auth().signIn(with: credential) {(authResult, error) in
                    if let error = error {
                        print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                    }
                    let dvc = storyboard.instantiateViewController(withIdentifier: "Dashboard") as! DashboardTabController
                    
                    dvc.modalPresentationStyle = .overFullScreen
                    
                    self.present(dvc, animated: false, completion: nil)
                }
                
            } else {
                Auth.auth().signIn(with: credential) {(authResult, error) in
                    if let error = error {
                        print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                    } else  {
                        let user = user.profile
                        self.firstName = (user?.givenName)!
                        self.secondName = (user?.familyName)!
                        self.emailId = (self.user?.email)!
                        self.userlocation = self.location.coordinate
                        
                        self.db.collection("users").document((self.user?.email)!).setData([
                            "email": self.emailId,
                            "firstName": self.firstName,
                            "secondName": self.secondName,
                            "longitude": Double(self.userlocation.longitude),
                            "latitude": Double(self.userlocation.latitude),
                            "completedRegistration": false
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
                                
                                print("Document successfully written!")
                            }
                        }
                        
                    }
                    let vVc = storyboard.instantiateViewController(withIdentifier: "Vegan") as! VeganViewController
                    vVc.modalPresentationStyle = .overFullScreen
                    self.present(vVc, animated: false, completion: nil)
                }
            }
        }
    }


extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("\(userIdentifier) \(String(describing: fullName)) \(String(describing: email))")
            
            
        }
        
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}

extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}



