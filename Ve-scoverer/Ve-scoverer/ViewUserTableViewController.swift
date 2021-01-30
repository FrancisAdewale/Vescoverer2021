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
            cell.layer.cornerRadius = 8
            cell.usernameCell.text = viewUser.firstName
            
            
            print("this is the view user image \(viewUser.image)")
            
            
            
            DispatchQueue.main.async {
                let ref = self.storage.reference().child(self.loadUserEmail).child("profile/profile.jpg")
                
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print(error)
                    } else {
                        
                        cell.imageCell.sd_setImage(with: url, completed: nil)
                        tableView.reloadData()
                        
                    }
                }
            }
            
            
            

            
                
                //.sd_setImage(with: URL(fileURLWithPath: viewUser.image), completed: nil)

           // cell.userImage.image = UIImage(contentsOfFile: userImage)
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
//               self.profileImage.clipsToBounds = true;
//
//            //cell.userImage.image = UIImage(contentsOfFile: section1.first!.image)
            return cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            
        
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.fillerInfo.text = viewUser.age.description
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
            return otherCell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.fillerInfo.text = viewUser.veganSince
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            otherCell.textLabel?.text = viewUser.gender
            otherCell.accessoryType = .none
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05
            otherCell.layer.cornerRadius = 8
            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "SocialsCell", for: indexPath) as! SocialsTableViewCell
            //otherCell.textLabel?.text = profileUser.twitter
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
            //button.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
            footerView.addSubview(button)
        }
        return footerView

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
//    func loadImage() {
//
//        let ref = storage.reference().child("\(loadUserEmail)/\(loadUserEmail)Profile.jpg")
//
//        ref.downloadURL { (url, error) in
//            if let error = error {
//                print(error)
//            } else {
//                self.imagefilepath = url!
//                print(self.imagefilepath)
//            }
//        }
//
//
//            self.tableView.reloadData()
//
//
//    }
    
//    @IBAction func uploadImagePressed(_ sender: UIButton) {
//        present(picker, animated: true, completion: nil)
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let userImage = info[.editedImage] as! UIImage
//        let jpegImage = userImage.jpegData(compressionQuality: 1.0)
//            //.pngData()
//        let coreImage = Image(context: context)
//        coreImage.img = jpegImage
//
//        do {
//            try! context.save()
//       }
//
//       // db.collection("users").document((user?.email!)!).collection("userimage").document("image").setData(["image": jpegImage as Any])
//
//
//        uploadImage.setImage(UIImage(data: jpegImage!), for: .normal)
//        dismiss(animated: true, completion: nil)
//
//    }
    
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
    
//    @IBAction func didTapSignOut(_ sender: AnyObject) {
//
//        print("signed out \(String(describing: user?.email))")
//
//        let firebaseAuth = Auth.auth()
//    do {
//      try firebaseAuth.signOut()
//          let lvc = storyboard?.instantiateViewController(identifier: "Login") as! LoginViewController
//          lvc.modalPresentationStyle = .fullScreen
//         present(lvc, animated: true, completion: nil)
//
//
//    } catch let signOutError as NSError {
//      print ("Error signing out: %@", signOutError)
//    }
//
//    }
    
    
    
//    func load() {
//
//        //profileName.text = expectedString
////        uploadImage.imageView?.image = expectedImage
////        logOutButton.isHidden = expectedBool
////        igButton.isEnabled = buttonIsEnabled
////        twitterButton.isEnabled = buttonIsEnabled
//
//
//        db.collection("users").document((user?.email)!).addSnapshotListener { (snapShot, err) in
//            if let err = err {
//                print(err)
//            } else {
//
//                let data = snapShot?.data()
//
//                self.profileUser.firstName = data?["firstName"] as? String ?? ""
//                self.profileUser.veganSince = data?["veganSince"] as? String ?? ""
//                self.profileUser.age = data?["age"] as? Int ?? 0
//                self.profileUser.gender = data?["gender"] as? String ?? ""
//                self.profileUser.instagram = data?["instagram"] as? String ?? ""
//                self.profileUser.twitter = data?["twitter"] as? String ?? ""
//                self.profileUser.image = data?["imagepath"] as? String ?? ""
//                self.profileUser.latitude = data?["latitude"] as? Double ?? 0
//                self.profileUser.longitude = data?["longitude"] as? Double ?? 0
//
//
////                let location = CLLocation(latitude: self.profileUser.latitude, longitude: self.profileUser.longitude)
////                location.fetchCityAndCountry { city, country, error in
////                    guard let city = city, let country = country, error == nil else { return }
////                    self.userCity = city + ", " + country
////                }
//
//                self.section1.append(self.profileUser)
//                self.section2.append(self.profileUser)
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//
//        }
//
//        //self.imagefilepath = data!["imagepath"] as! String
//
//    }
//        })
        
//        db.collection("users").document(user?.email ?? "Email").collection("socials").document("twitter").getDocument(completion: { (documentSnap, err) in
//            if let err = err {
//                print(err.localizedDescription)
//            }
//
//
//            if let data = documentSnap?.data() {
//                for document in data {
//
//                    self.editedTwitter = document.value as! String
//
//                }
//
//            }
//
//        })
                  
        }


    
