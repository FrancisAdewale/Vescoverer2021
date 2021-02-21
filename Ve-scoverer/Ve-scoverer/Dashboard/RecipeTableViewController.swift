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


class RecipeTableViewController: UITableViewController {
    
    var recipes = [Recipe]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        title = "Recipes"
        
        tableView.register(UINib(nibName: "RecipeViewCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")

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


        return cell
    }
    
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchData() {
      // 1
      let request = AF.request("https://api.spoonacular.com/recipes/complexSearch?apiKey=e742b07ea05f4a00ade106e82a60e347&diet=vegan&number=100")
      // 2
        request.responseDecodable(of: X.self) { (response) in
                guard let x = response.value else { return }
                self.recipes = x.results
            self.tableView.reloadData()

        }
    }
}
