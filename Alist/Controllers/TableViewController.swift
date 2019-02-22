//
//  ViewController.swift
//  Alist
//
//  Created by Jiacheng Xia on 2019-01-17.
//  Copyright © 2019 Jiacheng Xia. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TableViewController: SwipeTableViewController {
    
    
    
    var aListItems: Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
   
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        tableView.separatorStyle = .none
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour else { fatalError() }
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //    MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        
        
        guard let navBarColour = UIColor (hexString: colourHexCode) else{fatalError()}
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
    
    
    //MARK: - TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aListItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = aListItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(aListItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
                }
                
                
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = aListItems?[indexPath.row] {
            do{
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done
                }
            }catch {
                print ("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
//        print (itemArray[indexPath.row])
        
//        aListItems[indexPath.row].done = !aListItems[indexPath.row].done
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//         What will happen once the user clicks on the add item button
            
            if let currentCategory = self.selectedCategory {
                
                do{
                  try self.realm.write {
                      let newItem = Item()
                      newItem.title = textField.text!
                      newItem.dateCreated = Date()
                      currentCategory.items.append(newItem)
                  }
              }catch {
                  print ("Error saving new items, \(error)")
              }
            }
            
            self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    MARK: - Data Manipulation Methods
    
    func loadItems() {

        aListItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = aListItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print ("Error deleting item, \(error)")
            }
        }
    }
}


//MARK: - Search bar methods
extension TableViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        aListItems = aListItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()



    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
//          Code for dispatch the keyboard
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }


}


