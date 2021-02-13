//
//  FoundTableViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 06/11/2020.
//

import UIKit
import Firebase
import CoreLocation


class FoundTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    var userArray = [[String:Any]]()
    var userList = [String]()
    let currentUser = ""
    var loadUser = String()
    let user = Auth.auth().currentUser
    var profileUser = ProfileUser()
    var userCity = ""


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        view.backgroundColor = UIColor(hexString: "57AAB7")
        
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            if tabItem.badgeValue == "1" {
                tabItem.badgeValue = nil
            }
        }



    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vescovered"
        self.tableView.rowHeight = 71.0


    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        let label = userList[indexPath.row]
        cell.textLabel?.text = label
        cell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
        cell.backgroundColor = UIColor(hexString: "57AAB7")
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToProfile", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        guard let vup = segue.destination as? ViewUserTableViewController else { return }
        let indexpath = tableView.indexPathForSelectedRow

        if let unwrappedPath = indexpath {
            tableView.deselectRow(at: unwrappedPath, animated: true)
            let user = userList[unwrappedPath.row]
            print("i am the \(user)")
            vup.button.isHidden = true

            
            db.collection("users").document(user)
                .getDocument() { (snapShot, err) in
                if let err = err {
                    print(err)
                } else {
                    
                    let data = snapShot?.data()
                    
                    vup.viewUser.firstName = data?["firstName"] as? String ?? ""
                    vup.viewUser.veganSince = data?["veganSince"] as? String ?? ""
                    vup.viewUser.age = data?["age"] as? Int ?? 0
                    vup.viewUser.gender = data?["gender"] as? String ?? ""
                    vup.viewUser.instagram = data?["instagram"] as? String ?? ""
                    vup.viewUser.twitter = data?["twitter"] as? String ?? ""
                    //vup.viewUser.image = data?["imagepath"] as? String ?? ""
                    vup.viewUser.latitude = data?["latitude"] as? Double ?? 0
                    vup.viewUser.longitude = data?["longitude"] as? Double ?? 0
                    vup.viewUser.verified = data?["isVerified"] as? Bool ?? false
                    vup.loadUserEmail = data?["email"] as? String ?? ""
                    
                    
                    DispatchQueue.main.async {
                        vup.tableView.reloadData()

                    }
                    
   
                    let location = CLLocation(latitude: vup.viewUser.latitude, longitude: vup.viewUser.longitude)
                    location.fetchCityAndCountry { city, country, error in
                        guard let city = city, let country = country, error == nil else { return }
                        vup.userCity = city + ", " + country
                    }
                    
                
                    
                    
                }
                
            }
      
            }
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = Auth.auth().currentUser
            db.collection("users").document((user?.email)!).collection("found").document(userList[indexPath.row]).delete()
            self.userList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    
    func load() {
            
        let user = Auth.auth().currentUser

        
        db.collection("users").document((user?.email!)!).collection("found").getDocuments { (querySnapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)")
            } else {

                for document in querySnapshot!.documents {
                    if !self.userList.contains(document["email"] as! String){
                        self.userList.append(document["email"] as! String)

                    }
                }
                self.tableView.reloadData()


            }
        }
    }
}

