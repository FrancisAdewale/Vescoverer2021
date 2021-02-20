//
//  PostRecipe.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 20/02/2021.
//

import Foundation

struct Results: Decodable {
    
    let recipes: [Recipe]
    
}
struct Recipe: Decodable, Identifiable {
    
    var id: String {
        return objectID
    }
    
    let objectID: String
    let title: String
    let image: String
    let missedIngredients: [String]
    
    
}
