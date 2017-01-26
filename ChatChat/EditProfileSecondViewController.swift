//
//  EditProfileSecondViewController.swift
//  ChatChat
//
//  Created by Gelaina Stern on 12/22/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class EditProfileSecondViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var politicsTextField: UITextField!
    @IBOutlet weak var favoritesTextField: UITextField!
    @IBOutlet weak var interestsTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var username: String?
    var bio: String?
    
    var activeField: UITextField?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
        
        doneButton.layer.cornerRadius = 3

        locationTextField.text = ModelController.sharedController.user.location
        ageTextField.text = ModelController.sharedController.user.age
        politicsTextField.text = ModelController.sharedController.user.politics
        favoritesTextField.text = ModelController.sharedController.user.favorites
        interestsTextField.text = ModelController.sharedController.user.interests

    }
    
    
    

    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let newUsername = username else { return }
        guard let newBio = bio else { return }
        guard let newLocation = locationTextField.text else { return }
        guard let newAge = ageTextField.text else { return }
        guard let newPolitics = politicsTextField.text else { return }
        guard let newFavorites = favoritesTextField.text else { return }
        guard let newInterests = interestsTextField.text else { return }
        
        if newLocation.characters.count > 20 {
            
            let alert = UIAlertController(title: "Please shorten your location", message: "Your location must have fewer than 20 characters.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if newPolitics.characters.count > 50 {
            let alert = UIAlertController(title: "Please shorten your political views", message: "Your political views must have fewer than 50 characters.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if newFavorites.characters.count > 100 {
            let alert = UIAlertController(title: "Please shorten your favorites", message: "Your favorites must have fewer than 100 characters.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if newInterests.characters.count > 100 {
            let alert = UIAlertController(title: "Please shorten your interests", message: "Your interests must have fewer than 100 characters.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let userData = ["username": newUsername, "bio": newBio, "location": newLocation, "age": newAge, "politics": newPolitics, "favorites": newFavorites, "interests": newInterests, "uid": ModelController.sharedController.user.uid, "email": ModelController.sharedController.user.email]
            
            ModelController.sharedController.usersRef.child(ModelController.sharedController.user.uid).setValue(userData)
            
            ModelController.sharedController.user.username = newUsername
            ModelController.sharedController.user.bio = newBio
            ModelController.sharedController.user.location = newLocation
            ModelController.sharedController.user.age = newAge
            ModelController.sharedController.user.politics = newPolitics
            ModelController.sharedController.user.favorites = newFavorites
            ModelController.sharedController.user.interests = newInterests
            
            self.performSegue(withIdentifier: "unwindToProfile", sender: self)
        }
        
        
        
    }
    
    

}
