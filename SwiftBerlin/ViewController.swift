//
//  ViewController.swift
//  SwiftBerlin
//
//  Created by Arash Kashi on 3/24/17.
//  Copyright © 2017 Arash Kashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    private var searchDelegate: SearchDelegate = SearchDelegate()
    
    // TODO_5: sync the second table view with the first one.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTableView.dataSource     = self
        bottomTableView.dataSource  = self
        
        topTableView.delegate       = self
        
        UISearchBar.addToHeaderOf(tableview: topTableView
        , searchDelegate: searchDelegate) { (searchString) in
            
            // TODO_2: What happens when the user types something in the search box?
            //          1. Make a predicate with the text
            //          2. Feed the predicate to the NSFetchResultsController
            //          3. Perform the fetch
            //          4. Re-load the table
            
            print(searchString)
        }
    }
    
    
    @IBAction func onCreateTapped() {
        
        // TODO_1: 
        // 1. Insert a new object into local store
        // 2. Perform fetch request
        // 3. Reload the table
        // 4. make sure the data source is implemented, for rows and sections.
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == topTableView {
            
            return 0
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topTableView {
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            return cell
        } else {
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            return cell
        }
    }
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView == topTableView && editingStyle == .delete {
            
            // TODO_4: Implement how happens when a deleting an item from Local Database
            //          1. Fetch the object, using NSFetchResultsController from DataProvider
            //          2. Delete the object using the attached managed object context.
            //          3. Perform the save
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == topTableView {
            
            // TODO_3: Update the item
            //          1. show the create presenter
            //          2. Update the contact
            //          3. Save to data base using the attached managed object context
            //          4. perform the fetch on fetch results controller
            //          5. reload the table
        }
    }
}

