//
//  ImageViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 09/01/2021.
//

import UIKit
import SDWebImage

class ImageViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFirstName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
