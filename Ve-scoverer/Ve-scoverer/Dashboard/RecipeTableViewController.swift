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
    
    private var recipes = [Recipe]()
    private var filteredData = [Recipe]()
    private var activityItem = ""
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        AppStoreReviewManager.requestReviewIfAppropriate()

        title = "Recipes"
        
        tableView.register(UINib(nibName: "RecipeViewCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        
        filteredData = recipes
    
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .action, target: self, action: #selector(recommendTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(hexString: "3797a4")
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
        let url = recipe.image
        self.tableView.rowHeight = 90.0

        DispatchQueue.main.async {
            cell.recipeTitle.text = recipe.title
            cell.recipeImage.sd_setImage(with: try! url.asURL(), placeholderImage: UIImage(named:"placeholder"))
            cell.time.text = recipe.readyInMinutes.description

        }

        
        if isSearchBarEmpty == false {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Options", message: "Select", preferredStyle: .actionSheet)
        
        let goAction = UIAlertAction(title: "More Details", style: .default) { (action) in
            if let url = URL(string: self.recipes[indexPath.row].spoonacularSourceUrl) {
                 let config = SFSafariViewController.Configuration()

                 let vc = SFSafariViewController(url: url, configuration: config)

                self.present(vc, animated: true)
             }

        }
        
        let shareAction = UIAlertAction(title: "Share Recipe", style: .default) { (action) in
            self.activityItem = self.recipes[indexPath.row].spoonacularSourceUrl
            
            self.navigationItem.rightBarButtonItem?.addToolTip(description: "Added")
            self.navigationItem.rightBarButtonItem?.showToolTip()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(goAction)
        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)


    }
    

    private func fetchData() {
    
      // 1          
        let request = AF.request("https://api.spoonacular.com/recipes/complexSearch?apiKey=e742b07ea05f4a00ade106e82a60e347&diet=vegan&number=100&addRecipeInformation=True")
      // 2
        
        
        request.responseDecodable(of: X.self) { (response) in
                guard let x = response.value else { return }
                self.recipes = x.results
            //self.recipes.shuffle()
            print(self.recipes)
            self.recipes.shuffle()
            self.tableView.reloadData()

        }
    }
    
    private func filterContentForSearchText(_ searchText: String,
                                    category: Recipe? = nil) {
      filteredData = recipes.filter { (recipe : Recipe) -> Bool in
        return recipe.title.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }

    @objc private func recommendTapped() {
        
        
        let item = activityItem

        let avc = UIActivityViewController(activityItems: [item], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true, completion: nil)

    }


}


extension RecipeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        
        let searchBar = searchController.searchBar
        searchBar.tintColor = UIColor(hexString: "3797a4")
        filterContentForSearchText(searchBar.text!)

        
    }
    

}
