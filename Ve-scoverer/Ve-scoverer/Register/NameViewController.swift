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


    @IBOutlet var fullName: UIStackView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.insertSubview(self.background, at: 0)
        background.backgroundColor = UIColor(hexString: "3797A4")
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
    
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func done2(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func next(_ sender: Any) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: fullName.center.x - 10, y: fullName.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: fullName.center.x + 10, y: fullName.center.y))
        
        
        let avc = storyboard?.instantiateViewController(withIdentifier: "Age") as! AgeViewController
        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            avc.currentuser = user
            self.db.collection("users").document(user).setData(["firstName" : self.firstNameTextField.text!,"secondName": self.lastNameTextField.text!], merge: true)

                avc.modalPresentationStyle = .overFullScreen
            
            if !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
                
                present(avc, animated: true, completion: nil)

            } else {
                if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty {
                    fullName.layer.add(animation, forKey: "position")

                }
            }

        }
    }
    
}
