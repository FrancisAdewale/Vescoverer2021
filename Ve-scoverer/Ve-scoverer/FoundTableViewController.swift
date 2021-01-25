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
    var section1: [ProfileUser] = []
    var section2: [ProfileUser] = []
    let user = Auth.auth().currentUser
    var profileUser = ProfileUser()
    var userCity = ""


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        view.backgroundColor = UIColor(hexString: "57AAB7")

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vescovered"

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
        

        guard let pvc = segue.destination as? ProfileTableViewController else { return }
        let indexpath = tableView.indexPathForSelectedRow

        if let unwrappedPath = indexpath {
            tableView.deselectRow(at: unwrappedPath, animated: true)
            pvc.expectedString = userList[unwrappedPath.row]
            pvc.button.isHidden = true
            
            db.collection("users").document(pvc.expectedString).addSnapshotListener { (snapShot, err) in
                if let err = err {
                    print(err)
                } else {
                    
                    let data = snapShot?.data()
                    
                    self.profileUser.firstName = data?["firstName"] as? String ?? ""
                    self.profileUser.veganSince = data?["veganSince"] as? String ?? ""
                    self.profileUser.age = data?["age"] as? Int ?? 0
                    self.profileUser.gender = data?["gender"] as? String ?? ""
                    self.profileUser.instagram = data?["instagram"] as? String ?? ""
                    self.profileUser.twitter = data?["twitter"] as? String ?? ""
                    self.profileUser.image = data?["imagepath"] as? String ?? ""
                    self.profileUser.latitude = data?["latitude"] as? Double ?? 0
                    self.profileUser.longitude = data?["longitude"] as? Double ?? 0
                    
                    let location = CLLocation(latitude: self.profileUser.latitude, longitude: self.profileUser.longitude)
                    location.fetchCityAndCountry { city, country, error in
                        guard let city = city, let country = country, error == nil else { return }
                        self.userCity = city + ", " + country
                    }
                
                    self.section1.append(self.profileUser)
                    self.section2.append(self.profileUser)
                    
                    print(self.section1)
                    print(self.section2)
                    
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

        
    
 
