//
//  ProfileViewController.swift
//  Grocr
//
//  Created by Gelaina Stern on 11/18/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var signOffButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var politicsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!

    

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!

    
    
//    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
        
        bioLabel.layer.cornerRadius = 3
        bioLabel.layer.borderWidth = 1
        bioLabel.layer.borderColor = UIColor.black.cgColor
        
        
        editButton.layer.cornerRadius = 3
        
        signOffButton.layer.cornerRadius = 3
        
        
//        if let profileImageUrl = ModelController.sharedController.user?.profileImageUrl {
//            let url = URL(string: profileImageUrl)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//            
//                if error == nil {
//                    DispatchQueue.main.async {
//                        self.imageView?.image = UIImage(data: data!)
//                        self.imageView?.contentMode = .scaleToFill
//                    }
//                }
//            }).resume()
//        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        usernameLabel.text = ModelController.sharedController.user?.username
        bioLabel.text = ModelController.sharedController.user?.bio
        locationLabel.text = ModelController.sharedController.user?.location
        ageLabel.text = ModelController.sharedController.user?.age
        politicsLabel.text = ModelController.sharedController.user?.politics
        favoritesLabel.text = ModelController.sharedController.user?.favorites
        interestsLabel.text = ModelController.sharedController.user?.interests
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        reload()
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        reload()
    }
    
    
    func reload() {
        usernameLabel.text = ModelController.sharedController.user?.username
        bioLabel.text = ModelController.sharedController.user?.bio
        locationLabel.text = ModelController.sharedController.user?.location
        ageLabel.text = ModelController.sharedController.user?.age
        politicsLabel.text = ModelController.sharedController.user?.politics
        favoritesLabel.text = ModelController.sharedController.user?.favorites
        interestsLabel.text = ModelController.sharedController.user?.interests
    }
 
  
    @IBAction func signOffButtonTapped(_ sender: Any) {
        do {
            try FIRAuth.auth()!.signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }



}
