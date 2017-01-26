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

class ChannelListTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = .clear
        self.tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ModelController.sharedController.clearChannels()
        ModelController.sharedController.loadChannels() { self.tableView.reloadData() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ModelController.sharedController.clearMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ModelController.sharedController.clearChannels()
    }
    
    
    
    
    
    @IBAction func unwindToChanneList(segue: UIStoryboardSegue) {

    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelController.sharedController.channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelListTableViewCell else { return ChannelListTableViewCell() }
        cell.channel = ModelController.sharedController.channels[indexPath.row]
        
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                let alert = UIAlertController(title: "Unmatch this person", message: "Are you sure you want to unmatch with this person?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let action = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                    let channel = ModelController.sharedController.channels[indexPath.row]
                    let channelId = channel.userId
                    let otherChannelId = channel.otherUserId
                    
                    if channelId == "" || otherChannelId == "" {
                        channel.ref?.removeValue()
                    } else if channelId.contains(ModelController.sharedController.user.uid) {
                        channel.ref?.child("userId").setValue("")
                    } else {
                        channel.ref?.child("otherUserId").setValue("")
                    }
                    
                    
                    
                    ModelController.sharedController.channels.remove(at: indexPath.row)
                    self.tableView.reloadData()
                })
                alert.addAction(action)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }
          }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowChannel", sender: self)
    }
    

    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowChannel" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let chatVc = segue.destination as? ChatViewController
                {
                    if let navController = self.parent as? UINavigationController, let customTabBarController = navController.parent as? CustomTabBarViewController { customTabBarController.chatViewVC = chatVc }
                    let channel = ModelController.sharedController.channels[indexPath.row]
                    chatVc.channel = channel
                    chatVc.senderDisplayName = ModelController.sharedController.user.username
                    chatVc.channelRef = ModelController.sharedController.channelRef.child(channel.id)
                }
            }
        }
    }
    
}
