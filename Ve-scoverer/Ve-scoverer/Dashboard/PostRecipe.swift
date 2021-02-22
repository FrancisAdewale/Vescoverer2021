//
//  PostRecipe.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 20/02/2021.
//

import Foundation

struct X: Decodable {
    
    let results: [Recipe]
    
  
}

 
struct Recipe: Decodable {
    
    let id: Int
    let title: String
    let image: String
    let readyInMinutes: Int
    let spoonacularSourceUrl: String

}
