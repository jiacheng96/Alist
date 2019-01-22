//
//  ViewController.swift
//  Alist
//
//  Created by Jiacheng Xia on 2019-01-17.
//  Copyright © 2019 Jiacheng Xia. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var itemArray = ["Go to Richmond", "Pick up Chelsea", "Get license"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "AListArray") as? [String] {
            itemArray = items
        }
    }
    
//    TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
//    TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print (itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
//    Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//         What will happen once the user clicks on the add item button
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "AListArray")
            
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

