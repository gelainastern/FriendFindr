//
//  SignUpViewController.swift
//  Grocr
//
//  Created by Gelaina Stern on 11/16/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
 
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
  
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var bioTextField: UITextView!
    
//    @IBOutlet weak var myImageView: UIImageView!
//  
//    @IBOutlet weak var choosePictureButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    
//    let picker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
      
      passwordTextField.isSecureTextEntry = true
    
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "SignUp4")
        self.view.insertSubview(backgroundImage, at: 0)
        
//        myImageView.layer.cornerRadius = 2
//        myImageView.layer.borderWidth = 1
//        myImageView.layer.borderColor = UIColor.black.cgColor
        
        doneButton.layer.cornerRadius = 3
        
        
        
//        picker.delegate = self

    }

    
    
//    @IBAction func choosePictureButtonTapped(_ sender: Any) {
//        photoFromLibrary(sender: choosePictureButton)
//        
//        
//    }

    
    
    

    @IBAction func submitButtonTapped(_ sender: Any) {


      
      guard let email = emailTextField.text else { return }
      guard let password = passwordTextField.text else { return }
      guard let username = usernameTextField.text else { return }
      guard let bio = bioTextField.text else { return }

        
      
            if email == "" || password == "" || username == "" || bio == "" {
        
            let alert = UIAlertController(title: "Oops!", message: "Please fill out all required fields.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
            } else if password.characters.count < 8 {
        
            let alert = UIAlertController(title: "Re-enter your password", message: "Your password must be at least eight characters long.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
            } else if bio.characters.count > 160 {
        
            let alert = UIAlertController(title: "Please shorten your bio", message: "Your bio must have fewer than 160 characters.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        
            } else if username.characters.count > 20 {
                let alert = UIAlertController(title: "Please shorten your username", message: "Your username must have fewer than 20 characters.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            else {
        
                ModelController.sharedController.createUser(email: email, password: password, username: username, bio: bio /*image: self.myImageView.image!*/) {
                    
                    
                    
                    self.performSegue(withIdentifier: "unwindFromSignUp", sender: self)
                }
    
            
            }

    
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
//        
//        
//        if let chosenImage = info[UIImagePickerControllerOriginalImage] {
//            myImageView.contentMode = .scaleToFill //3
//            myImageView.image = chosenImage as? UIImage //4
//        } else if let editedImage = info[UIImagePickerControllerEditedImage] {
//            myImageView.contentMode = .scaleToFill //3
//            myImageView.image = editedImage as? UIImage //4
//        }
//        
//        dismiss(animated:true, completion: nil) //5
//        
//    }
//    
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//        
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
  

}
