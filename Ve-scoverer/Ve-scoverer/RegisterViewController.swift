//
//  RegisterViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 03/11/2020.
//

//import UIKit
//import Firebase
//import CoreData
//import CoreLocation
//import SwiftEntryKit
//
//class RegisterViewController: UIViewController, UITextFieldDelegate {
//
//
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    let db = Firestore.firestore()
//
//
//    @IBOutlet weak var goToLogin: UIBarButtonItem!
//    @IBOutlet weak var donePressed: UIButton!
//    @IBOutlet weak var logInBar: UIToolbar!
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//
//
//
//    override func viewDidLoad() {
//        super .viewDidLoad()
//        hideKeyboardWhenTappedAround()
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        navigationItem.hidesBackButton = true
//        view.backgroundColor = UIColor(hexString: "3797A4")
//        logInBar.barTintColor = UIColor(hexString: "3797A4")
//        donePressed.tintColor = .white
//        goToLogin.tintColor = .white
//
//    }
//
//
//
//
//
//
//
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//
//
//    // rename function name
//    @IBAction func donePressed(_ sender: UIButton) {
//
//
//            let user = User(email: emailTextField.text!, password: passwordTextField.text!)
//
//
//
//            Auth.auth().createUser(withEmail: user.email, password: user.password) { (result, error) in
//                if let e = error {
//                    print(e)
//                } else {
//                    //different viewController
//                    let dvc =  self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! DashboardTabController
//                    dvc.modalPresentationStyle = .fullScreen
//                    self.present(dvc, animated: true, completion: nil)
//
//                }
//            }
//
//    }
//
//
//    @IBAction func loginPressed(_ sender: UIBarButtonItem) {
//
//        let lvc = storyboard?.instantiateViewController(identifier: "Login") as! LoginViewController
//        lvc.modalPresentationStyle = .fullScreen
//        present(lvc, animated: true, completion: nil)
//    }
//
//}
//
//
