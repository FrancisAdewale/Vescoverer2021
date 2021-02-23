//
//  RecipeTableViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 20/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import WebKit
import SafariServices


class RecipeTableViewController: UITableViewController {
    
    var recipes = [Recipe]()
    
    var filteredData = [Recipe]()

    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        title = "Recipes"
        
        tableView.register(UINib(nibName: "RecipeViewCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        
        filteredData = recipes
        

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        definesPresentationContext = true


    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return filteredData.count
        }
          
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeViewCell
        
        let recipe: Recipe
          if isFiltering {
            recipe = filteredData[indexPath.row]
          } else {
            recipe = recipes[indexPath.row]
          }
        cell.recipeTitle.text = recipe.title
        let url = recipe.image
        self.tableView.rowHeight = 90.0

        DispatchQueue.main.async {
            cell.recipeImage.sd_setImage(with: try! url.asURL(), placeholderImage: UIImage(named:"placeholder"))
        }

        cell.time.text = recipe.readyInMinutes.description


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let url = URL(string: recipes[indexPath.row].spoonacularSourceUrl) {
             let config = SFSafariViewController.Configuration()

             let vc = SFSafariViewController(url: url, configuration: config)
             present(vc, animated: true)
         }


    }
    

    func fetchData() {
    
      // 1
        let request = AF.request("https://api.spoonacular.com/recipes/complexSearch?apiKey=e742b07ea05f4a00ade106e82a60e347&diet=vegan&number=100&addRecipeInformation=True")
      // 2
        request.responseDecodable(of: X.self) { (response) in
                guard let x = response.value else { return }
                self.recipes = x.results
            //self.recipes.shuffle()
            print(self.recipes)
            self.tableView.reloadData()

        }
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: Recipe? = nil) {
      filteredData = recipes.filter { (recipe : Recipe) -> Bool in
        return recipe.title.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }


}


extension RecipeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        
        let searchBar = searchController.searchBar
        searchBar.tintColor = UIColor(hexString: "3797a4")
        filterContentForSearchText(searchBar.text!)

        
//        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//                 recipes = recipes.filter { recipe in
//                    return recipe.title.lowercased().contains(searchText.lowercased())
//                 }
//
//        } else {
//            recipes.shuffle()
//        }
        
    }
    
    
}
