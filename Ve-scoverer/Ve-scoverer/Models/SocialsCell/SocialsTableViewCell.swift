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
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func instagramTapped(_ sender: UIButton) {
        
        
        
        print(instagramAt)
        
        
    }
    
    @IBAction func twitterTapped(_ sender: UIButton) {
        
        print(twitterAt)
        
    }
}
