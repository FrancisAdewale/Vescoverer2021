//
//  UploadViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 18/12/2020.
//

import UIKit
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    var currentuser = ""
    
    var imagePath = ""
    let storage = Storage.storage()

    let db = Firestore.firestore()
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var uploadLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    

    @IBAction func uploadPressed(_ sender: UIButton) {

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
    
    
    @IBAction func next(_ sender: Any) {
        
        
        
        
        let svc = storyboard?.instantiateViewController(withIdentifier: "Social") as! SocialsViewController
        
        let user = Auth.auth().currentUser
        
        if let user = user?.email {
            svc.currentuser = user
            db.collection("users").document(currentuser).setData(["imagepath" : imagePath], merge: true)
            

            svc.modalPresentationStyle = .overFullScreen
            present(svc, animated: true, completion: nil)

            
        }
        
        
    }
    
}
