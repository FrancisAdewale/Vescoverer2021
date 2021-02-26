//
//  SocialsViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 18/12/2020.
//

import UIKit
import Firebase
import SwiftyToolTip


class SocialsViewController: UIViewController {
    
    var instagramLink = ""
    var twitterWebLink = ""
    var instagram: String?
    var twitter: String?
    
    
    @IBOutlet var twitterButton: UIButton!
    @IBOutlet var instaButton: UIButton!
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
        let lvc = storyboard?.instantiateViewController(withIdentifier: "Loading") as! LoadingViewViewController
        lvc.modalPresentationStyle = .overFullScreen
     
        
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
            
        //PRESENT LAUNCHPAD SCREEN AGAIN BEFORE PRESENTING DVC // also add random ratings popup.
            present(lvc, animated: true) {
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                    self.dismiss(animated: true) {
                        self.present(dvc, animated: true, completion: nil)
                    }
                }
            }

        }
        

    
    }
    
    @IBAction func instagramPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let actionsheet = UIAlertController(title: "Add Instagram @", message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let alert = UIAlertController(title: "Add your @", message: "only the suffix", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                self.instagramLink += "\(textField.text!)"
                self.instagram = self.instagramLink
                self.instaButton.addToolTip(description: textField.text!)

                    
            }
            alert.addTextField { (alertTextField) in
                textField = alertTextField

                
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionsheet.addAction(editAction)
        actionsheet.addAction(cancelAction)

        
        present(actionsheet, animated: true, completion: nil)
        
      
        
    }
    
    
    @IBAction func twitterPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let actionsheet = UIAlertController(title: "Add Twitter @", message: "", preferredStyle: .actionSheet)
        
        
        let editAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let alert = UIAlertController(title: "Add your @", message: "only the suffix", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
  
                self.twitterWebLink += "\(textField.text!)"
                self.twitter = self.twitterWebLink
                self.twitterButton.addToolTip(description: textField.text!)



            }
            alert.addTextField { (alertTextField) in
                textField = alertTextField

                
            }
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionsheet.addAction(editAction)
        actionsheet.addAction(cancelAction)

        present(actionsheet, animated: true,completion: nil)
        

        
        
    }
    
//    func makeLoadingView(withFrame frame: CGRect, loadingText text: String?) -> UIView? {
//        let loadingView = UIView(frame: frame)
//        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
//        activityIndicator.layer.cornerRadius = 6
//        activityIndicator.center = loadingView.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.style = .white
//        activityIndicator.startAnimating()
//        activityIndicator.tag = 100 // 100 for example
//
//        loadingView.addSubview(activityIndicator)
//        if !text!.isEmpty {
//            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//            let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
//            lbl.center = cpoint
//            lbl.textColor = UIColor.white
//            lbl.textAlignment = .center
//            lbl.text = text
//            lbl.tag = 1234
//            loadingView.addSubview(lbl)
//        }
//        return loadingView
//    }
//
//    func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
//        let existingView = UIApplication.shared.windows[0].viewWithTag(1200)
//        if show {
//            if existingView != nil {
//                return
//            }
//            let loadingView = self.makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
//            loadingView?.tag = 1200
//            UIApplication.shared.windows[0].addSubview(loadingView!)
//        } else {
//            existingView?.removeFromSuperview()
//        }
//
//    }
    
}
