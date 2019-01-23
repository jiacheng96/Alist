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
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Go to Richmond"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy car"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go to Vancouver"
        itemArray.append(newItem3)
        
        
        
        if let items = defaults.array(forKey: "AListArray") as? [Item] {
            itemArray = items
        }
    }
    
//    TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
        return cell
    }
    
//    TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print (itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
//    Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//         What will happen once the user clicks on the add item button
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
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

