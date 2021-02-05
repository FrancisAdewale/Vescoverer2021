//
//  NameViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 17/12/2020.
//

import UIKit
import Firebase
import GoogleSignIn


class NameViewController: UIViewController, UITextFieldDelegate {
    
    let db  = Firestore.firestore()
    var firstName = ""
    var lastName = ""
    let user = Auth.auth().currentUser
    var usersid = ""


    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
//        tHIS IS PROGRESS BAR COORDINATES (40.0, 78.0, 340.0, 2.6666666666666665)
//        THIS IS LABEL COORDINATES (40.0, 122.0, 163.33333333333334, 70.0)
//        THIS IS PICKER COORDINATES(79.0, 332.0, 262.0, 158.0)
//        THIS IS NET BUTTON COORDINATES(328.0, 778.0, 80.0, 80.0)

        self.view.insertSubview(self.background, at: 0)


        
        db.collection("users").document((user?.email)!).getDocument(completion: { (snapShot, err) in
            if let err = err {
                print(err)
            } else {
                if let document = snapShot!.data() {
                    self.firstNameTextField.text = (document["firstName"] as? String)
                    self.lastNameTextField.text = (document["secondName"] as? String)
                }
            }
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        let lvc = LoginViewController()
        
        firstName = lvc.firstName
        lastName = lvc.secondName
        hideKeyboardWhenTappedAround()

    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
            firstNameTextField.backgroundColor = .green
            lastNameTextField.backgroundColor = .green
        } else {
            if firstNameTextField.text!.isEmpty {
                firstNameTextField.backgroundColor = .red
            } else if lastNameTextField.text!.isEmpty {
                lastNameTextField.backgroundColor = .red
            }
        }
    }
    
    @IBAction func next(_ sender: Any) {
        
        
        let avc = storyboard?.instantiateViewController(withIdentifier: "Age") as! AgeViewController

        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            avc.currentuser = user
            self.db.collection("users").document(user).setData(["firstName" : self.firstNameTextField.text!,"secondName": self.lastNameTextField.text!], merge: true)
            
          
            
            
                avc.modalPresentationStyle = .overFullScreen
                present(avc, animated: true, completion: nil)

        }
    }
    
}
