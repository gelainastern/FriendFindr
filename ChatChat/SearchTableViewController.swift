//
//  SearchTableViewController.swift
//  ChatChat
//
//  Created by Gelaina Stern on 11/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textField: UITextField!
    
    
    
    var pickerView: UIPickerView?
    var pickerView2: UIPickerView?
    var pickerView3: UIPickerView?
    
    var pickOption = ["Bio", "Username", "Location", "Age", "Politics", "Favorites", "Interests"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        
        self.tableView.separatorColor = .clear
        
        searchBar.delegate = self
        
        pickerView = UIPickerView()
        
        self.textField.delegate = self
        
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        
        textField.inputView = pickerView
        
        pickerView?.isHidden = true
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = self.pickOption[row]
        self.pickerView?.isHidden = true
        self.pickerView?.removeFromSuperview()
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        
        if searchBar.text != "" {
            result = ModelController.sharedController.users.count
        }
        
        return result
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? SearchTableViewCell else { return SearchTableViewCell() }
        cell.user = ModelController.sharedController.users[indexPath.row]
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        guard let criteria = textField.text else { return }
        
        filterUsers(searchText: searchTerm, criteria: criteria)
    }
    
    func searchBarShouldReturn(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        guard let criteria = textField.text else { return }
        filterUsers(searchText: searchTerm, criteria: criteria)
    }
    

    func filterUsers(searchText: String, criteria: String, scope: String = "All") {
        ModelController.sharedController.search(searchText: searchText, criteria: criteria) { self.tableView.reloadData() }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.pickerView?.isHidden = false
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
    


}
