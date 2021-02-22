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

    let apiKey = "e742b07ea05f4a00ade106e82a60e347"

    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        title = "Recipes"
        
        tableView.register(UINib(nibName: "RecipeViewCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        
        filteredData = recipes
        

        searchBar.placeholder = "Search Recipe"
        //searchBar.delegate = self
        //searchBar.showsCancelButton = true
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        //tableView.tableHeaderView = searchController.searchBar



    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeViewCell
        cell.recipeTitle.text = recipes[indexPath.row].title
        let url = recipes[indexPath.row].image
        self.tableView.rowHeight = 90.0

        DispatchQueue.main.async {
            cell.recipeImage.sd_setImage(with: try! url.asURL(), placeholderImage: UIImage(named:"placeholder"))
        }

        cell.time.text = recipes[indexPath.row].readyInMinutes.description


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
            self.recipes.shuffle()
            print(self.recipes)
            self.tableView.reloadData()

        }
    }
    
    

}


//MARK: - Search bar method
extension RecipeTableViewController: UISearchBarDelegate {
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //RealmSwift Version            //predicate below(query)
     print("search")
        
        //core data version
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(to: request, predicate: predicate)
 


    }
   

}



extension RecipeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                 recipes = recipes.filter { recipe in
                    return recipe.title.lowercased().contains(searchText.lowercased())
                 }
                 
        } else {
            fetchData()
            
        }
        
    }
    
    
}
