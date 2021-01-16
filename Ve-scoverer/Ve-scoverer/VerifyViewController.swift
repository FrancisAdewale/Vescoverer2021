//
//  VerifyViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 05/11/2020.
//

import UIKit
import Firebase


//could change to a calander to schedule meetups. minimum of 6 people more females than male.
class VerifyViewController : UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let storage = Storage.storage()
    
    let user = Auth.auth().currentUser
    
    let picker = UIImagePickerController()

    @IBOutlet weak var userVerificationImage: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userVerificationImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(takeSelfie))
        tap.numberOfTapsRequired = 1
        userVerificationImage.addGestureRecognizer(tap)
     
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        
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
                Auth.auth().currentUser?.sendEmailVerification
                {
                    (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    } else {
                    }
                }
            }
        }
   
    }
    
    @objc func takeSelfie() {
        
        present(picker, animated: true, completion: nil)

        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let storageRef = storage.reference()

        
        let userImage = info[.editedImage] as! UIImage
        
        guard let imageData = userImage.jpegData(compressionQuality: 0.5) else { return }
            
        
        let imageRef = storageRef.child("\((user!.email)!)").child("spoonpic.jpg")
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
              guard let downloadURL = url else {
                // Uh-oh, an error occurred!
                return
              }
            }
        }

        dismiss(animated: true, completion: nil)

    }
}
