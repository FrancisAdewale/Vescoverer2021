//
//  ViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 03/11/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var isVegan: UISwitch! // may need coredata
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ve-scoverer"
        isVegan.isOn = false
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        
        if isVegan.isOn ==  true {
            let rvc =  storyboard?.instantiateViewController(withIdentifier: "register") as! RegisterViewController
            rvc.modalPresentationStyle = .fullScreen
            self.present(rvc, animated: true, completion: nil)
        }
        
    }
}

