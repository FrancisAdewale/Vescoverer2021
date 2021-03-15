//
//  AgeViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 17/12/2020.
//

import UIKit
import Firebase


class AgeViewController: UIViewController {
    
    private var calculatedAge = Int()
    private let db = Firestore.firestore()
    
    
    @IBOutlet weak private var background: UIImageView!
    @IBOutlet weak private var nextButton: UIButton!
    @IBOutlet weak private var ageLabel: UILabel!
    @IBOutlet weak private var progressBar: UIProgressView!
    @IBOutlet weak private var ageSelector: UIDatePicker!
    @IBOutlet weak private var age: UILabel!
    
    lazy var dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
    
    @IBOutlet weak var questionLabel: UILabel!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ageSelector.setValue(UIColor.black, forKeyPath: "textColor")

        let date = dateFormatter.string(from: ageSelector.date)

        let birthday = dateFormatter.date(from: date)
        let timeInterval = birthday?.timeIntervalSinceNow
        let calculatedAge = abs(Int(timeInterval! / 31556926.0))
        age.text = calculatedAge.description
        background.backgroundColor = UIColor(hexString: "3797A4")
        self.view.insertSubview(self.background, at: 0)

    }
    
    @IBAction private func selectedAge(_ sender: UIDatePicker) {
        
        let date = dateFormatter.string(from: sender.date)

        let birthday = dateFormatter.date(from: date)
        let timeInterval = birthday?.timeIntervalSinceNow
        calculatedAge = abs(Int(timeInterval! / 31556926.0))
        
        age.text = calculatedAge.description
         
    }
    
    @IBAction private func next(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            self.db.collection("users").document(user).setData(["age" : Int(age.text!)!], merge: true)

            self.performSegue(withIdentifier: "goToGender", sender: self)

        }
  
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
}
