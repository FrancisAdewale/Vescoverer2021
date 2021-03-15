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
import GoogleMobileAds


class ViewUserTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, GADBannerViewDelegate  {

    let picker = UIImagePickerController()
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    var viewUser = ViewUser()
    private let storage = Storage.storage()
    var loadUserEmail = ""
    private var bannerView: GADBannerView!
    var userCity = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-5752925768003309~8805739283"
        bannerView.rootViewController = self
        bannerView.delegate = self

        bannerView.load(GADRequest())

       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ViewImageCell", bundle: nil), forCellReuseIdentifier: "ViewCell")
        tableView.register(UINib(nibName: "NormalViewCell", bundle: nil), forCellReuseIdentifier: "NormalCell")
        tableView.register(UINib(nibName: "ViewedSocialsTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewedSocialsCell")
    
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide.bottomAnchor,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
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
                        if self.viewUser.verified == true {
                            cell.verified.setImage(UIImage(named: "verified.png"), for: .normal)
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

            otherCell.contentView.layer.borderWidth = 0.05
            return otherCell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell
            otherCell.fillerInfo.text = "Vegan For: \(viewUser.veganSince)"
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05

            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell

            otherCell.textLabel?.text = viewUser.gender
            otherCell.accessoryType = .none
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05

            return otherCell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "ViewedSocialsCell", for: indexPath) as! ViewedSocialsTableViewCell
            otherCell.editedTwitter = viewUser.twitter
            otherCell.editedInstagram = viewUser.instagram


            otherCell.accessoryType = .none

            otherCell.contentView.layer.borderWidth = 0.05
            return otherCell
        } else {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: "NormalCell", for: indexPath) as! NormalViewCell

            otherCell.textLabel?.text = userCity
            otherCell.accessoryType = .none
            otherCell.textLabel?.font = UIFont(name: "Lato", size: 20.0)
            otherCell.contentView.layer.borderWidth = 0.05

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
         
        }
        return footerView

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
          bannerView.alpha = 1
        })
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }

 

}


    
