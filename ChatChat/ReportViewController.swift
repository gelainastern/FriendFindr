//
//  ReportViewController.swift
//  ChatChat
//
//  Created by Gelaina Stern on 11/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var otherUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() 

        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
        
        submitButton.layer.cornerRadius = 3
        cancelButton.layer.cornerRadius = 3
        
    }


    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        guard let textFieldText = textField?.text else { return }
        let username = self.otherUser!.username
        ModelController.sharedController.createReport(reporter: ModelController.sharedController.user.username, user: username, text: textFieldText)
        
        let alert = UIAlertController(title: "Your report has been submitted", message: "We'll look into the problem as soon as possible. Thank you for letting us know.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "unwindToTabView", sender: self)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }


    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "unwindToDetailVC", sender: self)
        
    }
    
    

    

}
