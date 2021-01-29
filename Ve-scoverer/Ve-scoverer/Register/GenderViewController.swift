//
//  GenderViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 18/12/2020.
//

import UIKit
import Firebase

class GenderViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate {

    let db = Firestore.firestore()
    var currentuser = ""
    
    var selectedGender = ""
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    @IBOutlet weak var genderLabel: UILabel!
    let gender = ["Male","Female","Trans"]

    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker.delegate = self
        genderPicker.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progressBar.tintColor = .black

      
        


    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        genderLabel.text = gender[row]
        selectedGender = gender[row]
        return gender[row]

        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
    }
    

    @IBAction func next(_ sender: UIButton) {
        
        let uvc = storyboard?.instantiateViewController(withIdentifier: "Upload") as! UploadViewController
        
        
        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            uvc.currentuser = user
            db.collection("users").document(currentuser).setData(["gender" : selectedGender], merge: true)
            

            uvc.modalPresentationStyle = .overFullScreen
            
            present(uvc, animated: true, completion: nil)
        }
    }

}
