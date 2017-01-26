//
//  ChannelListTableViewCell.swift
//  ChatChat
//
//  Created by Gelaina Stern on 12/22/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class ChannelListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        channel = nil
    }
    
    private func updateWithChannel() {
        
        
        guard let channel = channel else { return }
        
        if channel.userId.contains(ModelController.sharedController.user.uid) {
            self.nameLabel.text = channel.otherUser
            self.lastMessageLabel.text = channel.lastMessage
        } else {
            self.nameLabel.text = channel.user
            self.lastMessageLabel.text = channel.lastMessage
        }
        
    }
    
    
    var channel: Channel? {
        didSet {
            updateWithChannel()
        }
    }

}
