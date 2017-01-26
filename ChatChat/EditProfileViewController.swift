//
//  EditProfileViewController.swift
//  ChatChat
//
//  Created by Gelaina Stern on 11/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var bioField: UITextView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
//    @IBOutlet weak var imageView: UIImageView!
    
//    @IBOutlet weak var imageButton: UIButton!
    
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() 
        
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
        
        continueButton.layer.cornerRadius = 3
        doneButton.layer.cornerRadius = 3
        
//        imageView.layer.cornerRadius = 2
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.black.cgColor

        usernameField.text = ModelController.sharedController.user.username
        bioField.text = ModelController.sharedController.user.bio
        
        picker.delegate = self
    }
    
    
    
//    @IBAction func editPictureButtonTapped(_ sender: Any) {
//        
//        photoFromLibrary(sender: imageButton)
//        
//    }
    
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        guard let username = usernameField.text else { return }
        guard let bio = bioField.text else { return }
        
        if username.characters.count > 20 {
            
            let alert = UIAlertController(title: "Please shorten your username", message: "Your username must have fewer than 20 characters.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if bio.characters.count > 160 {
            
            let alert = UIAlertController(title: "Please shorten your bio", message: "Your bio must have fewer than 160 characters.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "continue", sender: self)
        }
        
    }
    
    

    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let newUsername = usernameField.text else { return }
        guard let newBio = bioField.text else { return }
        
        let userData = ["username": newUsername, "bio": newBio, "uid": ModelController.sharedController.user.uid, "email": ModelController.sharedController.user.email]
        
        ModelController.sharedController.usersRef.child(ModelController.sharedController.user.uid).setValue(userData)
        
        ModelController.sharedController.user.username = newUsername
        ModelController.sharedController.user.bio = newBio
        
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
        
    }
    
    
//    @IBAction func photoFromLibrary(_ sender: Any) {
//        picker.allowsEditing = false
//        picker.sourceType = .photoLibrary
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        present(picker, animated: true, completion: nil)
//    }
//    
//    
//    
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [String : AnyObject])
//    {
//        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        imageView.contentMode = .scaleToFill //3
//        imageView.image = chosenImage //4
//        dismiss(animated:true, completion: nil) //5
//        
//    }
//    
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//        
//    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "continue" {
            if let destinationVC = segue.destination as? EditProfileSecondViewController
            {
                guard let newUsername = usernameField.text else { return }
                guard let newBio = bioField.text else { return }
                destinationVC.username = newUsername
                destinationVC.bio = newBio
        }
    }
    }
    
    
    

}
