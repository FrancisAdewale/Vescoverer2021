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
    
    private let db  = Firestore.firestore()
    private var firstName = ""
    private var lastName = ""
    private let user = Auth.auth().currentUser


    @IBOutlet weak private var fullName: UIStackView!
    @IBOutlet weak private var background: UIImageView!
    @IBOutlet weak private var nextButton: UIButton!
    @IBOutlet weak private var progressBar: UIProgressView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var firstNameTextField: UITextField!
    @IBOutlet weak private var lastNameTextField: UITextField!
    
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
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .darkContent
//    }
//    
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction private func done2(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction private func next(_ sender: Any) {

        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            self.db.collection("users").document(user).setData(["firstName" : self.firstNameTextField.text!.capitalized,"secondName": self.lastNameTextField.text!.capitalized], merge: true)

        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: fullName.center.x - 10, y: fullName.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: fullName.center.x + 10, y: fullName.center.y))
        
        if firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty {
            
            fullName.layer.add(animation, forKey: "position")

            return false
            //present(avc, animated: true, completion: nil)

        } else {
            if !firstNameTextField.text!.isEmpty && !lastNameTextField.text!.isEmpty {
                self.performSegue(withIdentifier: "goToAge", sender: self)
            }
            return true

        }
    }
    
}
