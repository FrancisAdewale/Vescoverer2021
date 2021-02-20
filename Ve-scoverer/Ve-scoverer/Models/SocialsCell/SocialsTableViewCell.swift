//
//  SocialsTableViewCell.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 16/01/2021.
//

import UIKit
import Firebase

class SocialsTableViewCell: UITableViewCell {


    @IBOutlet var instagramButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    
    var instagramAt = ""
    var twitterAt = ""
    let vc = UIApplication.shared.topMostViewController()
    let user = Auth.auth().currentUser

    let db = Firestore.firestore()

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func instagramTapped(_ sender: UIButton) {
        
        
        
        var textField = UITextField()
    
        if !self.isEditing {
            let alert = UIAlertController(title: instagramAt.capitalized, message: "Current Instagram @", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .cancel, handler: nil)
            alert.addAction(action)
            vc!.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Edit", message: "Current Instagram: @\(instagramAt.capitalized)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default, handler: { action in
                
                let newInsta = textField.text!
                
                if let user = self.user {
                    self.db.collection("users").document(user.email!).setData(["instagram" : newInsta], merge: true)
                    DispatchQueue.main.async {

                        let storyboard = UIStoryboard(name: "Main", bundle: nil)

                        let pvc = storyboard.instantiateViewController(identifier: "Profile") as! ProfileTableViewController
                        pvc.tableView.reloadData()

                    }
                }
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            
            alert.addTextField { (alertField) in
                textField = alertField
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            print(textField.text!)
            vc!.present(alert, animated: true, completion: nil)
            
        
        }
 
    }
    
    
    @IBAction func twitterTapped(_ sender: UIButton) {
        
        var textField = UITextField()
        
        if !self.isEditing {
            let alert = UIAlertController(title: twitterAt.capitalized, message: "Current Twitter @", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .cancel, handler: nil)
            alert.addAction(action)
            vc!.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Edit", message: "Current Instagram: @\(twitterAt.capitalized)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Done", style: .default, handler: { action in
                let newTwit = textField.text!
                
                if let user = self.user {
                    self.db.collection("users").document(user.email!).setData(["twitter" : newTwit], merge: true)
                    DispatchQueue.main.async {

                        let storyboard = UIStoryboard(name: "Main", bundle: nil)

                        let pvc = storyboard.instantiateViewController(identifier: "Profile") as! ProfileTableViewController
                        pvc.tableView.reloadData()

                    }
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addTextField { (alertField) in
                textField = alertField
            }
            alert.addAction(action)
            alert.addAction(cancelAction)
            
            print(textField.text!)
            vc!.present(alert, animated: true, completion: nil)
            
        }
        
       

    }
    

}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return UIWindow.key!.rootViewController?.topMostViewController()
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}


