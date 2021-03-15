//
//  UploadViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 18/12/2020.
//

import UIKit
import Firebase
import SwiftyToolTip

class UploadViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let picker = UIImagePickerController()
    private var imagePath: String?
    private let storage = Storage.storage()

    private let db = Firestore.firestore()
    
    @IBOutlet weak private var uploadImage: UIButton!
    @IBOutlet weak private var progressBar: UIProgressView!
    @IBOutlet weak private var uploadLabel: UILabel!
    @IBOutlet weak private var nextButton: UIButton!
    @IBOutlet weak private var background: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImage.addToolTip(description: "Uploaded")

        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.insertSubview(self.background, at: 0)
        background.backgroundColor = UIColor(hexString: "3797A4")

    }
    

    @IBAction private func uploadPressed(_ sender: UIButton) {

        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let user = Auth.auth().currentUser!
        
        let userImage = info[.imageURL]
        let profileStorage = info[.originalImage] as! UIImage
        
        let url = userImage as! URL
        
        imagePath = url.path
        
        let storageRef = storage.reference()

        guard let imageData = profileStorage.jpegData(compressionQuality: 0.5) else { return }
        
        let imageRef = storageRef.child("\((user.email)!)").child("profile/profile.jpg")
        _ = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                return
              }
            // Metadata contains file metadata such as size, content-type.
           // let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard url != nil else {
                // Uh-oh, an error occurred!
                return
              }
            }
        }

        
        dismiss(animated: true) {
            self.uploadImage.showToolTip()

        }


    }
    
    
    @IBAction private func next(_ sender: Any) {

        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            if let path = imagePath {
                db.collection("users").document(user).setData(["imagepath" : path], merge: true)
                
            }
   
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: uploadImage.center.x - 10, y: uploadImage.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: uploadImage.center.x + 10, y: uploadImage.center.y))
        
        
        if imagePath == nil {
            uploadImage.layer.add(animation, forKey: "position")
            return false
            
        } else {
            
            performSegue(withIdentifier: "goToSocials", sender: self)
            return true
            //present(svc, animated: true, completion: nil)
            
        }
    }
    
    
    
}
