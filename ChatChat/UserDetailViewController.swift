//
//  UserViewController.swift
//  Grocr
//
//  Created by Gelaina Stern on 11/17/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

  var otherUser: User?
    var otherUserIndex: Int?
  
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var politicsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    
    
//    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var goToChannelButton: UIButton!
  
    @IBOutlet weak var seeMoreButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upButton.layer.borderWidth = 0.0
        downButton.layer.borderWidth = 0.0
        
        self.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)

      usernameLabel.text = otherUser?.username
      bioLabel.text = otherUser?.bio
        locationLabel.text = otherUser?.location ?? ""
        ageLabel.text = otherUser?.age ?? ""
        politicsLabel.text = otherUser?.politics ?? ""
        favoritesLabel.text = otherUser?.favorites ?? ""
        interestsLabel.text = otherUser?.interests ?? ""
        
        self.sendMessageButton.isHidden = false
        self.goToChannelButton.isHidden = true
        
        bioLabel.layer.cornerRadius = 3
        bioLabel.layer.borderWidth = 1
        bioLabel.layer.borderColor = UIColor.black.cgColor
        bioLabel.layer.backgroundColor = UIColor.white.cgColor
        
        
        sendMessageButton.layer.cornerRadius = 3
        
        goToChannelButton.layer.cornerRadius = 3
        
        seeMoreButton.layer.cornerRadius = 3
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Report", style: .plain, target: self, action: #selector(barButtonItemClicked))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        
        
//        if let profileImageUrl = ModelController.sharedController.otherUser?.profileImageUrl {
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        ModelController.sharedController.clearMessages()
    }
    
    @IBAction func unwindToDetailVC(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToDetailView(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromChatView(segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        ModelController.sharedController.checkChannels() {
            if ModelController.sharedController.channel != nil {
                self.sendMessageButton.isHidden = true
                self.goToChannelButton.isHidden = false
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        ModelController.sharedController.channel = nil
    }
    
    func barButtonItemClicked() {
        self.performSegue(withIdentifier: "ToReport", sender: self)
    }
    

    @IBAction func sendMessageButtonTapped(_ sender: Any) {
    
        
        ModelController.sharedController.createChannel(user: ModelController.sharedController.user.username, otherUser: ModelController.sharedController.otherUser.username, userId: ModelController.sharedController.user.uid, otherUserId: ModelController.sharedController.otherUser.uid, lastMessage: "", userLastRead: "", otherUserLastRead: "")
        ModelController.sharedController.checkChannels() {  ModelController.sharedController.channels.append(ModelController.sharedController.channel)
            self.performSegue(withIdentifier: "ToChatScreen", sender: self) }
    
    }
    
    
    
    @IBAction func goToChannelButtonTapped(_ sender: Any) {
        
        ModelController.sharedController.checkChannels() {
            self.performSegue(withIdentifier: "ToChatScreen", sender: self) }
        
    }
    
    
    
    
    @IBAction func upButtonTapped(_ sender: Any) {
        if (self.otherUserIndex! - 1) >= 0 {
            self.otherUserIndex = self.otherUserIndex! - 1
            ModelController.sharedController.otherUser = ModelController.sharedController.users[otherUserIndex!]
            self.otherUser = ModelController.sharedController.otherUser
            self.viewDidLoad()
        }
        
    }
    
    

    @IBAction func downButtonTapped(_ sender: Any) {
        if (self.otherUserIndex! + 1) < ModelController.sharedController.users.count {
            self.otherUserIndex = self.otherUserIndex! + 1
            ModelController.sharedController.otherUser = ModelController.sharedController.users[otherUserIndex!]
            self.otherUser = ModelController.sharedController.otherUser
            self.viewDidLoad()
        }
        
    }
  

  
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToChatScreen" {
            if let channel = ModelController.sharedController.channel {
                if let chatVc = segue.destination as? ChatViewController
                {
                    if let navController = self.parent as? UINavigationController, let customTabBarController = navController.parent as? CustomTabBarViewController { customTabBarController.chatViewVC = chatVc }
                    ModelController.sharedController.cameFromUserVC = true
                    chatVc.channel = channel
                    chatVc.senderDisplayName = ModelController.sharedController.user.username
                    chatVc.channelRef = ModelController.sharedController.channelRef.child(channel.id)
                }
            }
        }
        
        if segue.identifier == "ToReport" {
                if let destinationVC = segue.destination as? ReportViewController
                {
                    destinationVC.otherUser = otherUser
                }
        }
        
        if segue.identifier == "toSeeMore" {
            if let destinationVC = segue.destination as? SeeMoreViewController
            {
                destinationVC.otherUser = otherUser
            }
        }
      
    }
    

}
