//
//  ViewImageCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 30/01/2021.
//

import UIKit
import SwiftyToolTip


class ViewImageCell: UITableViewCell {
    
    
    @IBOutlet weak var verified: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var usernameCell: UILabel!
    
    let vc = UIApplication.shared.topMostViewController()


    override func awakeFromNib() {
        super.awakeFromNib()
        
        //imageCell.layer.cornerRadius = 0.5 * imageCell.bounds.size.width
        imageCell.clipsToBounds = true
        
        imageCell.layer.cornerRadius = (imageCell.frame.size.width) / 2
        imageCell.layer.borderWidth = 1.5
        imageCell.layer.borderColor = UIColor(hexString: "3797a4")?.cgColor
   

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    

    @IBAction func verifiedTapped(_ sender: UIButton) {
        
        if verified.isHidden == false {
            verified.showToolTip()
            

        }
    }
}


