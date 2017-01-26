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

class UsersTableViewController: UITableViewController {

  // MARK: Constants
  let userCell = "UserCell"
  
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
    self.tableView.separatorColor = .clear
    navigationController?.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)

    
    ModelController.sharedController.usersList() { self.tableView.reloadData() }
    
    
  }
  

    @IBAction func unwindToTabView(segue: UIStoryboardSegue) {
        
    }

  

  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ModelController.sharedController.users.count
  }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as? UserTableViewCell else { return UserTableViewCell() }
        cell.user = ModelController.sharedController.users[indexPath.row]

    return cell
  }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDetailVC", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
  
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ToDetailVC" {
      if let indexPath = tableView.indexPathForSelectedRow {
        if let destinationVC = segue.destination as? UserDetailViewController
        {
            ModelController.sharedController.otherUser = ModelController.sharedController.users[indexPath.row]
            ModelController.sharedController.userIndex = indexPath.row
          destinationVC.otherUser = ModelController.sharedController.otherUser
            destinationVC.otherUserIndex = ModelController.sharedController.userIndex
        }
      }
    }
  }
  
  // MARK: Actions
  
  
}
