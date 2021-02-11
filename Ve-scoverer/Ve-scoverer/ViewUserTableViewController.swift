//
//  ProfileViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 05/11/2020.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage
import ChameleonFramework
import GoogleSignIn
import AuthenticationServices
import SDWebImage


class ViewUserTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var editedInstagram = String()
    var editedTwitter = String()
    let picker = UIImagePickerController()
    var expectedString = ""
    var expectedImage = UIImage()
    var buttonIsEnabled = true
    var expectedBool = Bool()
    var isUserVerified = Bool()
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    var imagefilepath: URL? = nil
    var userFirstName = ""
    var profileUser = ProfileUser()
    var viewUser = ViewUser()
    let button = UIButton()
    let storage = Storage.storage()
    var loadUserEmail = ""
    var floatNum = CGFloat()

    var userImage = ""
    var userCity = ""
    
    var section1: [ProfileUser] = []
    var section2: [ProfileUser] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

                
    }
    

    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var igButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var isVerified: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var tab: UITabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatNum = CGFloat.random(in: 0...1)
        

        


        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = profileUser.firstName
      
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ViewImageCell", bundle: nil), forCellReuseIdentifier: "ViewCell")
        tableView.register(UINib(nibName: "NormalViewCell", bundle: nil), forCellReuseIdentifier: "NormalCell")
        tableView.register(UINib(nibName: "SocialsTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialsCell")

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3

        } else {
            return 3
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0 || section == 1 )
        {
            return 50.0;
        }
        else
        {
            return CGFloat.leastNormalMagnitude;
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor(hexString: "3797A4")
        return vw
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexpath = tableView.indexPathForSelectedRow
        tableView.deselectRow(at: indexpath!, animated: true)
    }
    
  

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath) as! ViewImageCell
            cell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            cell.contentView.layer.borderWidth = 0.05
//            cell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)
            cell.usernameCell.text = viewUser.firstName
            
            print("this is the view user image \(viewUser.image)")
            
            
            
            DispatchQueue.main.async {
                let ref = self.storage.reference().child(self.loadUserEmail).child("profile/profile.jpg")
                
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print(error)
                    } else {
                        
                        
                        cell.imageCell.sd_setImage(with: url, completed: nil)
                        
                        
                        if self.viewUser.verified == true {
                            
                            cell.verified.image = UIImage(named: "verified.png")
                                
                                //.sd_setImage(with: URL(fileURLWithPath: path), completed: nil)
                            
                        }
                        
                        tableView.reloadData()
                        
                    }
                }
            }
            
            
        
            return cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
        
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.fillerInfo.text = viewUser.age.description
//            otherCell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)

            otherCell.contentView.layer.borderWidth = 0.05
            return otherCell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.fillerInfo.text = viewUser.veganSince
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
//            otherCell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)

            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
//            otherCell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)

            otherCell.textLabel?.text = viewUser.gender
            otherCell.accessoryType = .none
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05

            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "SocialsCell", for: indexPath) as! SocialsTableViewCell
            //otherCell.textLabel?.text = profileUser.twitter
            //otherCell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)

            otherCell.accessoryType = .none

            //otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
            return otherCell
        } else {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell

            otherCell.textLabel?.text = userCity
            otherCell.accessoryType = .none
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
//            otherCell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)

            return otherCell
            
            
            
        }
        
   
        
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 60
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        if section == 1 {
            footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:
            100)
         
//            footerView.backgroundColor = UIColor(hexString: "3797A4")
        }
        return footerView

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    

    

    

    
    //i need to add social media lnks to USER MODEL.
    
//    @IBAction func igButtonClick(_ sender: Any) {
//
//        var textField = UITextField()
//
//        let actionsheet = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
//
//        let goAction = UIAlertAction(title: "Go", style: .default) { (action) in
//
//            let appURL = URL(string: "instagram://user?username=\(self.editedInstagram)")!
//            let application = UIApplication.shared
//
//            if application.canOpenURL(appURL) {
//                application.open(appURL)
//            } else {
//                let webURL = URL(string: "https://instagram.com/\(self.editedInstagram)")!
//                application.open(webURL)
//            }
//        }
//
//        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
//
//            let alert = UIAlertController(title: "Edit your @", message: "only your account name(not including @)", preferredStyle: .alert)
//
//            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
//                self.editedInstagram = textField.text!
//
////                self.db.collection("users").document((self.user?.email!)!).collection("socials").document("instagram").setData(["insta@": self.editedInstagram])
//
//
//            }
//            alert.addTextField { (alertTextField) in
//                textField = alertTextField
//
//            }
//            alert.addAction(action)
//
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        actionsheet.addAction(goAction)
//        actionsheet.addAction(editAction)
//
//        present(actionsheet, animated: true, completion: nil)
//    }
    
    
//    @IBAction func twitterButtonClicked(_ sender: Any) {
//
//        var textField = UITextField()
//
//        let actionsheet = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
//
//        let goAction = UIAlertAction(title: "Go", style: .default) { (action) in
//
//            let appURL = URL(string: "twitter://user?screen_name=\(self.editedTwitter)")!
//            let application = UIApplication.shared
//
//            if application.canOpenURL(appURL) {
//                application.open(appURL)
//            } else{
//                let webURL = URL(string: "https://twitter.com/\(self.editedTwitter)")!
//                application.open(webURL)
//            }
//
//
//        }
//
//        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
//
//            let alert = UIAlertController(title: "Edit your @", message: "only your account name(not including @)", preferredStyle: .alert)
//
//            let action = UIAlertAction(title: "Edit", style: .default) { (action) in
//                self.editedTwitter = textField.text!
////
////                self.db.collection("users").document((self.user?.email!)!).collection("socials").document("twitter").setData(["twitter@": self.editedTwitter])
//
//
//            }
//            alert.addTextField { (alertTextField) in
//                textField = alertTextField
//
//            }
//            alert.addAction(action)
//
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        actionsheet.addAction(goAction)
//        actionsheet.addAction(editAction)
//
//        present(actionsheet, animated: true, completion: nil)
//
//
//    }
    
    
    
    
}


    
