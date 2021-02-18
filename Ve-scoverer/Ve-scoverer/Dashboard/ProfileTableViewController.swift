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



class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
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
    var imagefilepath = ""
    var userFirstName = ""
    var profileUser = ProfileUser()
    let button = UIButton()
    var path = ""
    let storage = Storage.storage()
    var imagePath: String?


    
    var userCity = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editButton.title = "Edit"
        
        load()
        
    }
    
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var igButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var isVerified: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var tab: UITabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = "Account"
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
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
        return vw
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 && indexPath.row == 0 {
            
            let cell = tableView.cellForRow(at: indexPath) as! ImageViewCell
            
            if cell.userImage.isHighlighted {
                self.present(picker, animated: true, completion: nil)
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return true
        } else if indexPath.section == 1 && indexPath.row == 1 {
            return true
        }
        else {
            return false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
            cell.isUserInteractionEnabled = true
            cell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            cell.contentView.layer.borderWidth = 0.05
            cell.layer.cornerRadius = 8
            cell.userNameField.text = profileUser.firstName
            cell.userNameField.isEnabled = true
            cell.userNameField.isUserInteractionEnabled = true
            
            //.userFirstName.text = profileUser.firstName
            
            DispatchQueue.main.async {
                cell.userImage.sd_setImage(with: URL(fileURLWithPath: self.profileUser.image), completed: nil)
                
                if self.profileUser.verified == true {
                    
                    cell.verified.image = UIImage(named: "verified.png")
                    
                    //.sd_setImage(with: URL(fileURLWithPath: path), completed: nil)
                    
                }
                
            }
            return cell
            
            
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
            
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.fillerInfo.text = profileUser.age.description
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
            
            return otherCell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.fillerInfo.text = profileUser.veganSince
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
            
            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            otherCell.textLabel?.text = profileUser.gender
            otherCell.accessoryType = .none
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
            
            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "SocialsCell", for: indexPath) as! SocialsTableViewCell
            otherCell.twitterAt = profileUser.twitter
            otherCell.twitterButton.isEnabled = true
            otherCell.twitterButton.isUserInteractionEnabled = true
            otherCell.instagramButton.isEnabled = true
            otherCell.instagramButton.isUserInteractionEnabled = true
            otherCell.instagramAt = profileUser.instagram
            
            
            
            otherCell.accessoryType = .none
            //otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
            return otherCell
        } else {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            otherCell.textLabel?.text = userCity
            otherCell.accessoryType = .none
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
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
            button.frame = CGRect(x: 20, y: 10, width: 300, height: 50)
            button.setTitle("Logout", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
            footerView.addSubview(button)
        }
        return footerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        print("editTapped")
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        editButton.title = tableView.isEditing ? "Done" : "Edit"
        editButton.style = tableView.isEditing ? .done : .plain
        
        
        
    }
    
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        
        print("signed out \(String(describing: user?.email))")
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let lvc = storyboard?.instantiateViewController(identifier: "Login") as! LoginViewController
            lvc.modalPresentationStyle = .fullScreen
            present(lvc, animated: true, completion: nil)
            
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
    func load() {
        
        
        db.collection("users").document((user?.email)!).addSnapshotListener { (snapShot, err) in
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
                self.profileUser.verified = data?["isVerified"] as? Bool ?? false
                
                
                
                let resourcePath = Bundle.main.resourcePath
                let imgName = "verified.png"
                self.path = "\(resourcePath!)/\(imgName)"
                
                let location = CLLocation(latitude: self.profileUser.latitude, longitude: self.profileUser.longitude)
                location.fetchCityAndCountry { city, country, error in
                    guard let city = city, let country = country, error == nil else { return }
                    self.userCity = city + ", " + country
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        let userImage = info[.imageURL]
        let profileStorage = info[.originalImage] as! UIImage
        
        let url = userImage as! URL
        
        imagePath = url.path
        
        
        let userFire = Auth.auth().currentUser
        
        if let user = userFire?.email {
            if let path = imagePath {
                db.collection("users").document(user).setData(["imagepath" : path], merge: true)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

