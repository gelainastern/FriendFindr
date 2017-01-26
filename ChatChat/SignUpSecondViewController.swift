//
//  SignUpSecondViewController.swift
//  ChatChat
//
//  Created by Gelaina Stern on 12/19/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SignUpSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
    }
    

    
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        
        
        
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromSignup" {
            
        }
    }

}
