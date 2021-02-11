//
//  ViewImageCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 30/01/2021.
//

import UIKit

class ViewImageCell: UITableViewCell {
    
    
    @IBOutlet weak var verified: UIImageView!
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var usernameCell: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
