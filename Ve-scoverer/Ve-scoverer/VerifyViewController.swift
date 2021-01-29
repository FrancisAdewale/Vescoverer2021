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
    
    let db  = Firestore.firestore()
    let storage = Storage.storage()
    let user = Auth.auth().currentUser
    var isVerified = false
    let picker = UIImagePickerController()

    @IBOutlet weak var userVerificationImage: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var verifiedImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        userVerificationImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(takeSelfie))
        tap.numberOfTapsRequired = 1
        userVerificationImage.addGestureRecognizer(tap)
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        progress.backgroundColor = .black
        view.backgroundColor = UIColor(hexString: "3797A4")
//        let user = Auth.auth().currentUser
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
           // let size = metadata.size
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
    
    func load() {
        
        db.collection("users").document((user?.email)!).addSnapshotListener { (snapShot, error) in
            let data = snapShot?.data()!
            
            self.isVerified = data!["isVerified"] as! Bool
            
            if self.isVerified == true {
                self.progress.progress = 1.0
                self.label.text = "Verified!"
                self.verifiedImage.image = UIImage(systemName: "checkmark")
                self.viewWillAppear(true)
            } else {
                self.progress.progress = 0.5
                self.label.text = "Upload clear spoon selfie"
            }
            print(self.isVerified)
        }
        
    }
}
