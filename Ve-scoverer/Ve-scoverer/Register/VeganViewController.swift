//
//  VeganViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 17/12/2020.
//

import UIKit
import Firebase


class VeganViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedRow = ""
    var currentuser = ""
    
    let db =  Firestore.firestore()

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var veganLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var veganSince: UIPickerView!
    @IBOutlet weak var veganQuestion: UILabel!
    let times = ["<20 years","<10 years","<5 years","<2 years", "<1 year", "<6 months" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        title = "Register"
        self.view.insertSubview(self.background, at: 0)
        background.backgroundColor = UIColor(hexString: "3797A4")


        //print("\(progressBar.frame)")
        
//        db.collection("users").getDocuments { (snapShot, err) in
//            if let err = err {
//                print(err)
//            } else {
//                let documents = snapShot?.documents
//                for document in documents! {
//                    let data = document.data()
//                    for (k,v) in data {
//                        if k == "email" {
//                            self.currentuser = v as! String
//                            print(self.currentuser)
//                        }
//
//                    }
//
//                }
//            }
//        }
        veganSince.dataSource = self
        veganSince.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedRow = times[row]
        
        
        return times[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    @IBAction func next(_ sender: Any) {
        

        let user = Auth.auth().currentUser
                            
        if let user = user?.email {
            self.db.collection("users").document(user).setData(["veganSince" : selectedRow], merge: true)
//
//            nvc.modalPresentationStyle = .overFullScreen
//            present(nvc, animated: true, completion: nil)
//
//
            self.performSegue(withIdentifier: "goToName", sender: self)


        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
}
