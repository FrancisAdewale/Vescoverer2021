//
//  AgeViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 17/12/2020.
//

import UIKit
import Firebase


class AgeViewController: UIViewController {
    
    var currentuser = ""

    var calculatedAge = Int()
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var ageSelector: UIDatePicker!
    @IBOutlet weak var age: UILabel!
    
    lazy var dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()
    
    @IBOutlet weak var questionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        let date = dateFormatter.string(from: ageSelector.date)

        let birthday = dateFormatter.date(from: date)
        let timeInterval = birthday?.timeIntervalSinceNow
        let calculatedAge = abs(Int(timeInterval! / 31556926.0))
        age.text = calculatedAge.description

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.frame = CGRect(x: 36.0, y: 37.5, width: 240.0, height: 2.5)

        ageLabel.frame = CGRect(x: 36.0, y: 58.0, width: 207.5, height: 70.0)
        nextButton.frame = CGRect(x: 211.0, y: 433.0, width: 80.0, height: 80.0)
    }
    


    @IBAction func selectedAge(_ sender: UIDatePicker) {
        
        let date = dateFormatter.string(from: sender.date)

        let birthday = dateFormatter.date(from: date)
        let timeInterval = birthday?.timeIntervalSinceNow
        calculatedAge = abs(Int(timeInterval! / 31556926.0))
        
        print(calculatedAge)
        age.text = calculatedAge.description
        
        
        
        if (calculatedAge < 20) {
            questionLabel.text = "Aww, a baby"
        } else if (calculatedAge < 30) {
            questionLabel.text = "Roaring 20's"
        } else if (calculatedAge < 40) {
            questionLabel.text = "You're still young"
        } else if (calculatedAge < 50) {
            questionLabel.text = "Cheer Up"
        } else {
            questionLabel.text = "V-gang!"
        }
        
        
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        db.collection("users").document(currentuser).setData(["age" : Int(age.text!)!], merge: true)

        let gvc = storyboard?.instantiateViewController(withIdentifier: "Gender") as! GenderViewController
        
        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            gvc.currentuser = user
            self.db.collection("users").document(user).setData(["age" : Int(age.text!)!], merge: true)
            
       
            
            gvc.modalPresentationStyle = .overFullScreen
            present(gvc, animated: true, completion: nil)

        }

        
    }
}
