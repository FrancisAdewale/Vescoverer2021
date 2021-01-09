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


    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.collection("users").document((user?.email)!).getDocument(completion: { (snapShot, err) in
            if let err = err {
                print(err)
            } else {
                let document = snapShot!.data()
                self.firstNameTextField.text = String(describing: document!["firstName"])
                self.lastNameTextField.text = String(describing: document!["secondName"])
                
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
    
    @IBAction func next(_ sender: Any) {
        let avc = storyboard?.instantiateViewController(withIdentifier: "Age") as! AgeViewController

        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            avc.currentuser = user
            avc.modalPresentationStyle = .overFullScreen
            present(avc, animated: true, completion: nil)

        }
    }
    
}
