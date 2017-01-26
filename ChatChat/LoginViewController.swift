/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

  // MARK: Constants
  let loginToList = "LoginToList"
  let toSignUp = "ToSignUp"
  
  let detailVC = SignUpViewController()
  var user: User?
    
  
  // MARK: Outlets
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    
    self.textFieldLoginEmail.delegate = self
    self.textFieldLoginPassword.delegate = self
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "MainScreen")
    self.view.insertSubview(backgroundImage, at: 0)
    
    FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
        if user != nil {
            ModelController.sharedController.currentUsersChanged(auth: auth, user: user!)
            self.performSegue(withIdentifier: "LoginToList", sender: self)
        }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
    
  }
    
  
  @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    
  }
    
    @IBAction func unwindFromSignup(segue: UIStoryboardSegue) {
        
        let alert = UIAlertController(title: "Success!", message: "You successfully registered.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Let's go!", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "LoginToList", sender: self)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
  
  
    @IBAction func loginDidTouch(_ sender: Any) {
        guard let email = textFieldLoginEmail.text else { return }
        guard let password = textFieldLoginPassword.text else { return }
        
        
        if email == "" || password == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()!.signIn(withEmail: email, password: password, completion: { (authData, error) in
                if error != nil
                {
                    
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else
                {
                    self.textFieldLoginEmail.text = ""
                    self.textFieldLoginPassword.text = ""
                    self.performSegue(withIdentifier: "LoginToList", sender: self)
                }

            })

        }
    }
  

    @IBAction func signUpDidTouch(_ sender: Any) {
    self.performSegue(withIdentifier: self.toSignUp, sender: nil)
    }

    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
