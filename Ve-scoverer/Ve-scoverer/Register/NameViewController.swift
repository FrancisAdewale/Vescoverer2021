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


    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progressBar.tintColor = .black

        
      

        

        
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
