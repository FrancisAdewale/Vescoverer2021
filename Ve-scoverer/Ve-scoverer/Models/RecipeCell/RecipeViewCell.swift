//
//  RecipeViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 21/02/2021.
//

import UIKit
import WebKit

class RecipeViewCell: UITableViewCell {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeTitle: UILabel!
    @IBOutlet var readyIn: UILabel!
    @IBOutlet var time: UILabel!
    
    
    @IBAction func recipeTapped(_ sender: UIButton) {
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
