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
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var genderLabel: UILabel!
    let gender = ["Male","Female"]

    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        self.view.insertSubview(self.background, at: 0)
        background.backgroundColor = UIColor(hexString: "3797A4")

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
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
