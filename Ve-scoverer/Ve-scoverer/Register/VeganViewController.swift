//
//  VeganViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 17/12/2020.
//

import UIKit
import Firebase


class VeganViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var selectedRow = ""
    
    private let db =  Firestore.firestore()

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var veganLabel: UILabel!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var veganSince: UIPickerView!
    @IBOutlet private weak var veganQuestion: UILabel!
    private let times = ["<20 years","<10 years","<5 years","<2 years", "<1 year", "<6 months" ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        title = "Register"
        self.view.insertSubview(self.background, at: 0)
        background.backgroundColor = UIColor(hexString: "3797A4")

        veganSince.dataSource = self
        veganSince.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        veganSince.setValue(UIColor.black, forKeyPath: "textColor")


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
    
    @IBAction private func next(_ sender: Any) {
        

        let user = Auth.auth().currentUser
                            
        if let user = user?.email {
            self.db.collection("users").document(user).setData(["veganSince" : selectedRow], merge: true)

            self.performSegue(withIdentifier: "goToName", sender: self)


        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
}
