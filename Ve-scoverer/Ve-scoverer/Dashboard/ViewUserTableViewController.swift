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
    var instagramAppLink = String()
    var twitterAppLink = String()
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

    

    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var igButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var isVerified: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var tab: UITabBarItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        floatNum = CGFloat.random(in: 0...1)

        //self.navigationController?.navigationBar.prefersLargeTitles = true
        title = profileUser.firstName
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ViewImageCell", bundle: nil), forCellReuseIdentifier: "ViewCell")
        tableView.register(UINib(nibName: "NormalViewCell", bundle: nil), forCellReuseIdentifier: "NormalCell")
        tableView.register(UINib(nibName: "ViewedSocialsTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewedSocialsCell")
    
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath) as! ViewImageCell
            cell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            cell.contentView.layer.borderWidth = 0.05
//            cell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)
            cell.usernameCell.text = viewUser.firstName
            cell.verified.addToolTip(description: "Verified!")

            DispatchQueue.main.async {
                let ref = self.storage.reference().child(self.loadUserEmail).child("profile/profile.jpg")
                
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print(error)
                    }
                    
                    else {
                        
                        cell.imageCell.sd_setImage(with: url, placeholderImage: UIImage(named:"placeholder"))
                        //cell.imageCell.sd_setImage(with: url, completed: nil)
                        
                        
                        if self.viewUser.verified == true {
                            
                            cell.verified.setImage(UIImage(named: "verified.png"), for: .normal)
                                
                                
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
            otherCell.fillerInfo.text = "\(viewUser.age.description) Years Old"
//            otherCell.backgroundColor = UIColor(hexString: "3797A4")!.lighten(byPercentage: self.floatNum)

            otherCell.contentView.layer.borderWidth = 0.05
            return otherCell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.fillerInfo.text = "Vegan For: \(viewUser.veganSince)"
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
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "ViewedSocialsCell", for: indexPath) as! ViewedSocialsTableViewCell
            otherCell.editedTwitter = viewUser.twitter
            otherCell.editedInstagram = viewUser.instagram

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

    

}


    
