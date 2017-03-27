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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTableView.dataSource     = self
        bottomTableView.dataSource  = self
        
        topTableView.delegate       = self
        
        UISearchBar.addToHeaderOf(tableview: topTableView
        , searchDelegate: searchDelegate) { (searchString) in
            
            // TODO: What happens when the user types something in the search box?
            //          1. make a predicate with the text
            //          2. feed the text to the NSFetchResultsController
            //          3. perform the fetch
            //          4. re-load the table
            print(searchString)
        }
    }
    
    
    @IBAction func onCreateTapped() {
        
    }
    
    @IBAction func onReadTapped() {
        
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
            
            // TODO: Implement how happens when a deleting an item from Local Database
            //          1. Fetch the object, using NSFetchResultsController from DataProvider
            //          2. Delete the object using the attached managed object context.
            //          3. Perform the save
        }
    }
}

