//
//  SocialsViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 18/12/2020.
//

import UIKit
import Firebase

class SocialsViewController: UIViewController {
    
    var instagramLink = "https://instagram.com/"
    var twitterWebLink = "https://twitter.com/"
    
    
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
        
        let dvc = storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! DashboardTabController

        
        let instagram = instagramLink
        let twitter = twitterWebLink
        
        db.collection("users").document(currentuser).setData([
            "instagram": instagram,
            "twitter": twitter,
            "completedRegistration": true,
            "isVerified": false
        ], merge: true)
        
            
        dvc.modalPresentationStyle = .currentContext
        
        present(dvc, animated: true, completion: nil)

        
    }
    
    @IBAction func instagramPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let actionsheet = UIAlertController(title: "Add Username", message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            let alert = UIAlertController(title: "Edit your @", message: "only your account name(not including @)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
                self.instagramLink += textField.text!
                
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
                
                self.twitterWebLink += textField.text!
                print(self.twitterWebLink)

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
