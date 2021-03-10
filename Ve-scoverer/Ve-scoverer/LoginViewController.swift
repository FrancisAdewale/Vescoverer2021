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
import CryptoKit


class LoginViewController: UIViewController, CLLocationManagerDelegate, GIDSignInDelegate {
    
    let appleView = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    let context = (UIApplication.shared.delegate as! AppDelegate)
    fileprivate var currentNonce: String?
    
    
    // @IBOutlet var appleView: ASAuthorizationAppleIDButton!
    @IBOutlet weak var googleView: GIDSignInButton!
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    let db = Firestore.firestore()
    var location = CLLocation()
    private let locationManager = CLLocationManager()
    var firstName = ""
    var secondName = ""
    var emailId = ""
    var user = Auth.auth().currentUser
    var userlocation = CLLocationCoordinate2D()
    var hasCompletedRegistration: Bool?
    var appleUser = ""
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        navigationItem.hidesBackButton = true
        background.backgroundColor = UIColor(hexString: "3797A4")
        // navigationController?.navigationBar.backgroundColor = .white
        //        appleButton.backgroundColor = .gray
        navigationController?.navigationBar.barTintColor = .white
        
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let unwrappedUser = user?.email {
                self.db.collection("users").document(unwrappedUser).getDocument { (document, error) in
                    
                    if let err = error {
                        print("this is the login viewwillappear eror \(err)")
                    } else {
                        if let dataDescription = document!.data() {
                            self.hasCompletedRegistration = (dataDescription["completedRegistration"] as! Bool)
                            
                            if self.hasCompletedRegistration == true {
                                
                                self.performSegue(withIdentifier: "goToDash", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "goToVegan", sender: self)
                            }
                        }
                        
                    }
                    
                    
                }
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //        if let unwrappedUser = user?.email {
        //            self.db.collection("users").document(unwrappedUser).getDocument { (document, error) in
        //
        //                if let err = error {
        //                    print("this is the login viewwillappear eror \(err)")
        //                } else {
        //                    if let dataDescription = document!.data() {
        //                        self.hasCompletedRegistration = (dataDescription["completedRegistration"] as! Bool)
        //                        print("login view did load \(self.hasCompletedRegistration)")
        //                        print(unwrappedUser)
        //
        //                    }
        //
        //                }
        //            }
        //        }
        //
        title = "Login"
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "Vescoverer"
        
        for l in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1555 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(l)
            }
            charIndex += 1
        }
        
        setupAppleButton()
        setupGoogleButton()
        
        //       GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyReduced
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
        
    }
    
    
    
    
    func setupAppleButton() {
        
        appleView.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        appleView.frame = CGRect(x: 117.0, y: 200, width: 184.0, height: 42.0)
        appleView.center = view.center
        appleView.cornerRadius = 0
        self.view.addSubview(appleView)
        
    }
    
    func setupGoogleButton() {
        
        let y = self.view.center.y
        
        let center = self.view.center
        googleView.frame = CGRect(x: 117.0, y: 200.0, width: 191.0, height: 42.0)
        googleView.center = .init(x: center.x, y: y - CGFloat(45))
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
        
        
        
        if let unwrappedUser = user?.profile {
            self.db.collection("users").document(unwrappedUser.email!).getDocument { (document, error) in
                
                if let err = error {
                    print("this is the login viewwillappear eror \(err)")
                } else {
                    if let dataDescription = document!.data() {
                        self.hasCompletedRegistration = (dataDescription["completedRegistration"] as! Bool)
                        print("login view will appear \(self.hasCompletedRegistration)")
                        
                        
                        if self.hasCompletedRegistration == nil {
                            
                            Auth.auth().signIn(with: credential) {(authResult, error) in
                                if let error = error {
                                    print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                                } else  {
                                    
                                    
                                    self.firstName = (unwrappedUser.givenName)!
                                    self.secondName = (unwrappedUser.familyName)!
                                    self.emailId = (unwrappedUser.email)!
                                    self.userlocation = self.location.coordinate
                                    
                                    self.db.collection("users").document((unwrappedUser.email)!).setData([
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
                                            
                                            
                                            self.performSegue(withIdentifier: "goToVegan", sender: self)
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                        }  else if self.hasCompletedRegistration == true {
                            // Sign in with Firebase.
                            Auth.auth().signIn(with: credential) { (authResult, error) in
                                if (error != nil) {
                                    
                                    
                                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                                    // you're sending the SHA256-hashed nonce as a hex string with
                                    // your request to Apple.
                                    print(error!.localizedDescription)
                                    return
                                } else {
                                    
                                    
                                    self.performSegue(withIdentifier: "goToDash", sender: self)
                                }
                                
                            }
                            
                        } else if self.hasCompletedRegistration == false {
                            
                            Auth.auth().signIn(with: credential) {(authResult, error) in
                                if let error = error {
                                    print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                                } else  {
                                    
                                    
                                    
                                    self.firstName = (unwrappedUser.givenName)!
                                    self.secondName = (unwrappedUser.familyName)!
                                    self.emailId = (unwrappedUser.email)!
                                    self.userlocation = self.location.coordinate
                                    
                                    self.db.collection("users").document((unwrappedUser.email)!).setData([
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
                                            
                                            
                                            self.performSegue(withIdentifier: "goToVegan", sender: self)
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    } else {
                        Auth.auth().signIn(with: credential) {(authResult, error) in
                            if let error = error {
                                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                            } else  {
                                
                                
                                self.firstName = (unwrappedUser.givenName)!
                                self.secondName = (unwrappedUser.familyName)!
                                self.emailId = (unwrappedUser.email)!
                                self.userlocation = self.location.coordinate
                                
                                self.db.collection("users").document((unwrappedUser.email)!).setData([
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
                                        
                                        
                                        self.performSegue(withIdentifier: "goToVegan", sender: self)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
        
        
        
        
    }
    
    
    
    //    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    //
    //        if identifier == "goToVegan" {
    //            if let user = self.user?.email {
    //
    //                self.db.collection("users").document(user).getDocument { (document, error) in
    //
    //                    if let err = error {
    //                        print("this is the login viewwillappear eror \(err)")
    //                    } else {
    //                        if let dataDescription = document!.data() {
    //                            self.hasCompletedRegistration = (dataDescription["completedRegistration"] as! Bool)
    //                            print("should perform method: \(self.hasCompletedRegistration)")
    //
    //
    //                        }
    //
    //                    }
    //                }
    //
    //            }
    //
    //        }
    //
    //        if self.hasCompletedRegistration == true {
    //            return false
    //        } else {
    //            return true
    //        }
    //    }
    
    
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



@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
//            if let user = Auth.auth().currentUser?.email {
//                
//                self.db.collection("users").document(user).getDocument { (document, error) in
//                    
//                    if let err = error {
//                        print("this is the login viewwillappear eror \(err)")
//                    } else {
//                        if let dataDescription = document!.data() {
//                            self.hasCompletedRegistration = (dataDescription["completedRegistration"] as! Bool)
//                            print("login view will appear \(self.hasCompletedRegistration)")
//                
//                        }
//                    }
//                }
//            }
//            
//            
//       
            
            
            
                
                // Sign in with Firebase.
                
                Auth.auth().signIn(with: credential) {(authResult, error) in
                    if let error = error {
                        print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                    } else  {
                        guard let user = authResult?.user else { return }
                        let email = user.email ?? ""
                        self.appleUser = email
                        
                        
                        self.db.collection("users").document(email).getDocument { (document, error) in
                            
                            if let err = error {
                                print("this is the login viewwillappear eror \(err)")
                            } else {
                                if let dataDescription = document!.data() {
                                    
                                    self.hasCompletedRegistration = (dataDescription["completedRegistration"] as! Bool)
                                    
                                    if self.hasCompletedRegistration == nil {
                                        
                                        self.userlocation = self.location.coordinate
                                        
                                        self.db.collection("users").document(email).setData([
                                            "email": email,
                                            "firstName": "",
                                            "secondName":"",
                                            "longitude": Double(self.userlocation.longitude),
                                            "latitude": Double(self.userlocation.latitude),
                                            "completedRegistration": false
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                self.performSegue(withIdentifier: "goToVegan", sender: self)
                                            }
                                        }
                                        
                                    }
                                    else if self.hasCompletedRegistration == true {
                                        
                                        
                                        
                                        self.performSegue(withIdentifier: "goToDash", sender: self)
                                        
                                        
                                    }
                                    
                                    
                                } else if self.hasCompletedRegistration == false {
                                    
                                    
                                    
                                    guard let user = authResult?.user else { return }
                                    let email = user.email ?? ""
                                    
                                    
                                    
                                    self.userlocation = self.location.coordinate
                                    
                                    self.db.collection("users").document(email).setData([
                                        "email": email,
                                        "firstName": "",
                                        "secondName":"",
                                        "longitude": Double(self.userlocation.longitude),
                                        "latitude": Double(self.userlocation.latitude),
                                        "completedRegistration": false
                                    ]) { err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                        }
                                    }
                                    
                                    
                                    
                                } else {
                                    
                                    
                                    guard let user = authResult?.user else { return }
                                    let email = user.email ?? ""
                                    
                                    
                                    
                                    self.userlocation = self.location.coordinate
                                    
                                    self.db.collection("users").document(email).setData([
                                        "email": email,
                                        "firstName": "",
                                        "secondName":"",
                                        "longitude": Double(self.userlocation.longitude),
                                        "latitude": Double(self.userlocation.latitude),
                                        "completedRegistration": false
                                    ]) { err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                        }
                                    }

                                    self.performSegue(withIdentifier: "goToVegan", sender: self)

                                }
                            }
                            //                                   else {
                            //
                            //
                            //
                            //                                                        guard let user = authResult?.user else { return }
                            //                                                        let email = user.email ?? ""
                            //
                            //                                                        self.userlocation = self.location.coordinate
                            //
                            //                                                        self.db.collection("users").document(email).setData([
                            //                                                            "email": email,
                            //                                                            "firstName": "",
                            //                                                            "secondName":"",
                            //                                                            "longitude": Double(self.userlocation.longitude),
                            //                                                            "latitude": Double(self.userlocation.latitude),
                            //                                                            "completedRegistration": false
                            //                                                        ]) { err in
                            //                                                            if let err = err {
                            //                                                                print("Error writing document: \(err)")
                            //                                                            } else {
                            //                                                                self.performSegue(withIdentifier: "goToVegan", sender: self)
                            //                                                            }
                            //                                                        }
                            //
                            //
                            //
                            //
                            //                                                }
                        }
                        
                        
                    }
                    
                    
                }
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    
}


