//
//  SearchTableViewCell.swift
//  ChatChat
//
//  Created by Gelaina Stern on 12/21/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
//    @IBOutlet weak var cellImageView: UIImageView!
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        user = nil
    }
    
    private func updateWithUser() {
        
        
        guard let user = user else { return }
        
        
        self.nameLabel.text = user.username
        self.bioLabel.text = user.bio
        
//        let profileImageUrl = user.profileImageUrl
//        let url = URL(string: profileImageUrl)
//        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//            
//            if error == nil {
//                DispatchQueue.main.async {
//                    self.cellImageView?.image = UIImage(data: data!)
//                    self.cellImageView?.contentMode = .scaleToFill
//                }
//            }
//        }).resume()
    }
    
    
    var user: User? {
        didSet {
            updateWithUser()
        }
    }

}
