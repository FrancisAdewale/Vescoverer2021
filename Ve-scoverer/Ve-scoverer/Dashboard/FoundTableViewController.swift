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
    
    private let db = Firestore.firestore()
    private var userList = [String]()

    private let user = Auth.auth().currentUser
    private var profileUser = ProfileUser()
    private var userCity = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.db.collection("users").document(user!.email!).setData(["badge": "0"], merge: true)

        
        load()
        view.backgroundColor = UIColor(hexString: "57AAB7")
                
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[3]
            if tabItem.badgeValue != nil {
                tabItem.badgeValue = nil

            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Vescovered"
        self.tableView.rowHeight = 71.0
        tableView.register(UINib(nibName: "FoundUserTableViewCell", bundle: nil), forCellReuseIdentifier: "FoundCell")
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundCell", for: indexPath) as! FoundUserTableViewCell
        let userLabel = userList[indexPath.row]
        
        db.collection("users").document(userLabel).getDocument(completion: { (snapShot, err) in
            if let err = err {
                print(err)
            } else {
                if let document = snapShot!.data() {
                    
                    cell.nameLabel.text = (document["firstName"] as? String)
                    let age = (document["age"] as? Int)
                    cell.ageLabel.text = age?.description
                    //self.lastNameTextField.text = (document["secondName"] as? String)
                }
                
                
            }
        })
        cell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
        cell.backgroundColor = UIColor(hexString: "57AAB7")
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToProfile", sender: self)
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()

        if userList.isEmpty {
            let message = UILabel(frame: CGRect(x: vw.center.x, y: vw.center.y, width: 300, height: 150))
            message.text = "Vescover vegans and view them here."
            message.font = UIFont(name: "Lato-Black", size: 15.0)
            message.textAlignment = NSTextAlignment.center
            vw.addSubview(message)
        }
      
        return vw
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        guard let vup = segue.destination as? ViewUserTableViewController else { return }
        let indexpath = tableView.indexPathForSelectedRow
        
        if let unwrappedPath = indexpath {
            tableView.deselectRow(at: unwrappedPath, animated: true)
            let user = userList[unwrappedPath.row]
            
            
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
            self.tableView.reloadData()
        }
    }
    
    private func load() {
        
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

