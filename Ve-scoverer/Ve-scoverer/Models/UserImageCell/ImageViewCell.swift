//
//  ImageViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 09/01/2021.
//

import UIKit
import SDWebImage

class ImageViewCell: UITableViewCell, UITextFieldDelegate  {

    
    @IBOutlet var userNameField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFirstName: UILabel!
    
    @IBOutlet weak var verified: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        userNameField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
          print("TextField did begin editing method called")
      }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        print("TextField did end editing method called\(String(describing: textField.text))")
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }

    
}
