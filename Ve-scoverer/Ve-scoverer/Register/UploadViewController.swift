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
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressBar.tintColor = .black


    }
    

    @IBAction func uploadPressed(_ sender: UIButton) {

        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let userImage = info[.imageURL]
        
        let url = userImage as! URL
        
        imagePath = url.path
        

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
