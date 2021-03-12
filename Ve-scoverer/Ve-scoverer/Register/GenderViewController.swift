//
//  GenderViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 18/12/2020.
//

import UIKit
import Firebase

class GenderViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate {

    private let db = Firestore.firestore()
    
    private var selectedGender = ""
    
    @IBOutlet weak private var background: UIImageView!
    @IBOutlet weak private var progressBar: UIProgressView!
    @IBOutlet weak private var genderPicker: UIPickerView!
    @IBOutlet weak private var nextButton: UIButton!
    
    @IBOutlet weak private var genderLabel: UILabel!
    private let gender = ["Male","Female"]

    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        self.view.insertSubview(self.background, at: 0)
        background.backgroundColor = UIColor(hexString: "3797A4")

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
    

    @IBAction private func next(_ sender: UIButton) {
        
            self.performSegue(withIdentifier: "goToUpload", sender: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            db.collection("users").document(user).setData(["gender" : selectedGender], merge: true)
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
}
