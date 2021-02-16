//
//  SocialsTableViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 16/01/2021.
//

import UIKit

class SocialsTableViewCell: UITableViewCell {


    @IBOutlet var instagramButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    
    var instagramAt = ""
    var twitterAt = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let popupTitle = "Edit Socials"
//        let message = "Edit your @: @\(instagramAt)"
//        let image = UIImage(named: "twitterProfile.jpg")
//        let popup = PopupDialog(title: popupTitle, message: message, image: image)
//        
//        let buttonOne = CancelButton(title: "CANCEL") {
//            print("You canceled the car dialog.")
//        }
//
//        let buttonTwo = DefaultButton(title: "Edit", dismissOnTap: true) {
//            print("What a beauty!")
//        }
//
//        popup.addButtons([buttonOne, buttonTwo])

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        

        // Configure the view for the selected state
    }
    
    
    @IBAction func instagramTapped(_ sender: UIButton) {
        
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit", message: "Edit your @", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            self.instagramAt = textField.text!
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)

        
        print(instagramAt)
        
        
    }
    
    @IBAction func twitterTapped(_ sender: UIButton) {
        
        print(twitterAt)
    }
}
