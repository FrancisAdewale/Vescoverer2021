//
//  VerifyViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 05/11/2020.
//

import UIKit
import Firebase

//could change to a calander to schedule meetups. minimum of 6 people more females than male.
class VerifyViewController : UIViewController {
    
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress.backgroundColor = UIColor(hexString: "3797a4")
        
        view.backgroundColor = UIColor(hexString: "8bcdcd")
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            if user.isEmailVerified {
                self.progress.progress = 1.0
                self.label.text = "All Done!"
                verifiedImage.image = UIImage(systemName: "checkmark")

                self.viewWillAppear(true)
            } else {
//                Auth.auth().currentUser?.sendEmailVerification
//                {
//                    (error) in
//                    if error != nil {
//                        print(error!.localizedDescription)
//                        return
//                    } else {
//                    }
//                }
            }
        }
   
    }
}
