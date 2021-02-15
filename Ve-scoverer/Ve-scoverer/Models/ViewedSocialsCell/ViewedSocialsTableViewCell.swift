//
//  ViewedSocialsTableViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 15/02/2021.
//

import UIKit

class ViewedSocialsTableViewCell: UITableViewCell {

    @IBOutlet weak var instagram: UIButton!
    @IBOutlet weak var twitter: UIButton!
    
    var editedInstagram = ""
    var editedTwitter = ""
    var userEmail = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func tappedInstagram(_ sender: UIButton) {
        

        print(editedInstagram)
        
        let appURL = URL(string: "instagram://user?username=\(self.editedInstagram)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: "https://instagram.com/\(self.editedInstagram)")!
            application.open(webURL)
        }
        
        
    }
    
    
    @IBAction func tappedTwitter(_ sender: Any) {
        
        print(editedTwitter)
        
                let appURL = URL(string: "twitter://user?username=\(self.editedTwitter)")!
                let application = UIApplication.shared
        
                if application.canOpenURL(appURL) {
                    application.open(appURL)
                } else {
                    let webURL = URL(string: "https://twitter.com/\(self.editedTwitter)")!
                    application.open(webURL)
                }
                

    }
}
