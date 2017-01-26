//
//  SeeMoreViewController.swift
//  ChatChat
//
//  Created by Gelaina Stern on 1/9/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class SeeMoreViewController: UIViewController {

    var otherUser: User?
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var politicsLabel: UILabel!
    
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBOutlet weak var interestsLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.84, alpha: 1.0)

        usernameLabel.text = otherUser?.username
        bioLabel.text = otherUser?.bio
        locationLabel.text = otherUser?.location ?? ""
        ageLabel.text = otherUser?.age ?? ""
        politicsLabel.text = otherUser?.politics ?? ""
        favoritesLabel.text = otherUser?.favorites ?? ""
        interestsLabel.text = otherUser?.interests ?? ""
        
        doneButton.layer.cornerRadius = 3
    }
    

    @IBAction func doneButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "unwindToDetailView", sender: self)
        
    }
   

}
