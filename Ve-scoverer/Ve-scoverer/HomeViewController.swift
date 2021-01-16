//
//  ViewController.swift
//  Ve-scoverer
//
//  Created by Francis Adewale on 03/11/2020.
//

import UIKit
//import Firebase
import CoreData
import ChameleonFramework
import GoogleSignIn



class HomeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var vegan: [UserCore] = []
//    let db = Firestore.firestore()


    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var veganLabel: UILabel!
    @IBOutlet private weak var isVegan: UISwitch! // may need coredata
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismiss(animated: false, completion: nil)

        load()
        
        
        let lvc = storyboard?.instantiateViewController(withIdentifier: "Login")
        if !vegan.isEmpty {
            lvc!.modalPresentationStyle = .fullScreen
            present(lvc!, animated: true, completion: nil)
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}

        navBar.barTintColor = UIColor(hexString: "606060")
        veganLabel.textColor = .white
        isVegan.onTintColor = UIColor(hexString: "3797A4")
        isVegan.isOn = false
        

        if !isVegan.isOn {
            doneButton.addTarget(self, action: #selector(animate), for: .touchUpInside)
        } else {
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
       
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    @objc func animate() {
        
        logo.animationImages = animatedImages(for: "false")
        logo.animationDuration = 0.2
        logo.animationRepeatCount = 4
        logo.image = logo.animationImages?.first
        logo.startAnimating()
        logo.image = UIImage(named: "false/0")

    }
    
    
    func animatedImages(for name: String) -> [UIImage] {
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)/\(i)") {
            images.append(image)
            i += 1
        }
        
        return images
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let userEntity = UserCore(context: context) // might add username and password here
    
        if isVegan.isOn {
            userEntity.vegan = isVegan.isOn
            vegan.append(userEntity)
            save()
            
            return true
        }
        return false
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Could not save \(error)")
        }
    }
    
    func load() {
        let fetch = NSFetchRequest<UserCore>(entityName: "UserCore")
        do {
            let request  = try context.fetch(fetch)
            vegan = request
        } catch {
            print("Could not fetch \(error)")
        }
    }
}

