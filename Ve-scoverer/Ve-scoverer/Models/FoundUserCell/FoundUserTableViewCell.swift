//
//  FoundUserTableViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 26/02/2021.
//

import UIKit

class FoundUserTableViewCell: UITableViewCell {

    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
