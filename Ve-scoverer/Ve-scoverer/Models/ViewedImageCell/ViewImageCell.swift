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
        
        imageCell.layer.cornerRadius = 0.5 * imageCell.bounds.size.width
        imageCell.clipsToBounds = true
        
   

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

    }
    

    @IBAction func verifiedTapped(_ sender: UIButton) {
        
        verified.showToolTip()
    }
}


