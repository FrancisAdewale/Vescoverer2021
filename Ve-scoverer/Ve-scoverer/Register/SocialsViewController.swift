//
//  SocialsViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 18/12/2020.
//

import UIKit
import Firebase

class SocialsViewController: UIViewController {
    
    var instagramLink = ""
    var twitterWebLink = ""
    var instagram: String?
    var twitter: String?
    
    
    @IBOutlet weak var socials: UIStackView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var socialsLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var fullInstagramLink: UILabel!
    @IBOutlet weak var fullTwitterLink: UILabel!
    var editedInstagram = String()
    var editedTwitter = String()
    var currentuser = ""
    let db = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.view.insertSubview(self.background, at: 0)
        background.backgroundColor = UIColor(hexString: "3797A4")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func completeRegistration(_ sender: UIButton) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: socials.center.x - 10, y: socials.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: socials.center.x + 10, y: socials.center.y))
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! DashboardTabController
     
        
        if instagram == nil || twitter == nil {
            socials.layer.add(animation, forKey: "position")

        } else {
            
            db.collection("users").document(currentuser).setData([
                "instagram": instagram,
                "twitter": twitter,
                "completedRegistration": true,
                "isVerified": false
            ], merge: true)
            
                
            dvc.modalPresentationStyle = .currentContext
            
            present(dvc, animated: true, completion: nil)
        }

    
    }
    
    @IBAction func instagramPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let actionsheet = UIAlertController(title: "Add Username", message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            let alert = UIAlertController(title: "Edit your @", message: "only your account name(not including @)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
                self.instagramLink += "https://instagram.com/\(textField.text!)"
                self.instagram = self.instagramLink
            }
            alert.addTextField { (alertTextField) in
                textField = alertTextField
                
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionsheet.addAction(editAction)
        actionsheet.addAction(cancelAction)

        
        present(actionsheet, animated: true, completion: nil)
        
    }
    
    
    @IBAction func twitterPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let actionsheet = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
        
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            let alert = UIAlertController(title: "Edit your @", message: "only your account name(not including @)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
                
                
                
                self.twitterWebLink += "https://twitter.com/\(textField.text!)"
                self.twitter = self.twitterWebLink

            }
            alert.addTextField { (alertTextField) in
                textField = alertTextField
                
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        actionsheet.addAction(editAction)
        actionsheet.addAction(cancelAction)

        present(actionsheet, animated: true, completion: nil)
        
        
    }
    
    
}
