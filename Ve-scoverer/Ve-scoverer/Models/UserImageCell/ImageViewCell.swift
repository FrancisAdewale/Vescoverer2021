//
//  ImageViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 09/01/2021.
//

import UIKit
import SDWebImage
import Firebase

class ImageViewCell: UITableViewCell, UITextFieldDelegate  {

    
    @IBOutlet var userNameField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFirstName: UILabel!
    
    @IBOutlet weak var verified: UIImageView!
    let user = Auth.auth().currentUser

    let db = Firestore.firestore()

    override func awakeFromNib() {
        super.awakeFromNib()
     
        userNameField.delegate = self
        
        userImage.layer.cornerRadius = (userImage.frame.size.width) / 2
        userImage.clipsToBounds = true
        userImage.layer.borderWidth = 1.5
        userImage.layer.borderColor = UIColor.gray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
          print("TextField did begin editing method called")
      }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let newName = userNameField.text!
 
        if let user = user {
            self.db.collection("users").document(user.email!).setData(["firstName" : newName], merge: true)
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let pvc = storyboard.instantiateViewController(identifier: "Profile") as! ProfileTableViewController
                pvc.tableView.reloadData()
                
            }
            
            print("TextField did end editing method called\(String(describing: textField.text))")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        userNameField.font = UIFont(name: "Lato", size: 20.0)

        print("TextField should begin editing method called")
        
        if self.isEditing {
            return true

        }
        
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        userNameField.font = UIFont(name: "Lato", size: 20.0)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        print("TextField should return method called")
        textField.resignFirstResponder()
        return true
    }

    
}
