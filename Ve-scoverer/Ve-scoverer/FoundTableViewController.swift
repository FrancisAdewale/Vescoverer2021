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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
        view.backgroundColor = UIColor(hexString: "57AAB7")

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        guard let pvc = segue.destination as? ProfileTableViewController else { return }
//        let indexpath = tableView.indexPathForSelectedRow
//
//        if let unwrappedPath = indexpath {
//            tableView.deselectRow(at: unwrappedPath, animated: true)
//            pvc.expectedString = userList[unwrappedPath.row]
//
//            db.collection("users").document(pvc.expectedString).collection("userimage").getDocuments { (querySnapshot, err) in
//
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let data = document.data()
//                       // let image = UIImage(data: data["image"] as! Data)
//                        pvc.expectedImage = UIImage(named: "placeholder")!
//                        do {
//                        let users = try? Auth.auth().getStoredUser(forAccessGroup: "users")
//                            if users?.email == pvc.expectedString && users!.isEmailVerified == true {
//                                pvc.isUserVerified = true
//                            }
//                        } catch {
//                            print(error)
//                        }
//
//                    }
//                }
//            }
//        }
//        pvc.expectedBool = true
//        pvc.buttonIsEnabled = false
//    }
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
                    if !self.userList.contains(document["userFound"] as! String){
                        self.userList.append(document["userFound"] as! String)

                    }
                }
                self.tableView.reloadData()


            }
        }
    }
}

        
    
 
