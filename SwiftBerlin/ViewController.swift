//
//  ViewController.swift
//  SwiftBerlin
//
//  Created by Arash Kashi on 3/24/17.
//  Copyright © 2017 Arash Kashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    let dataProvider = DataProvider<Contact>(operationMode: .UI)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
    }
    
    @IBAction func onCreateTapped() {
        
        CreatePresenter.present(viewController: self) { (name, number) in
            
            self.dataProvider.insert(beforeSave: { (beforeSave) -> Bool in
                beforeSave!.name = name
                beforeSave!.number = number
                
                return true
            }, completion: { (savedContact) in
                
                try? self.dataProvider.fetchResultController.performFetch()
                self.tableView.reloadData()
            })
        }
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataProvider.fetchResultController.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "contactCell")
        
        let contact = dataProvider.fetchResultController.object(at: indexPath)
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.number
        
        return cell
    }
}

