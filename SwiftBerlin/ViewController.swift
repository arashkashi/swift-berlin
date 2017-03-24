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
    
    @IBOutlet weak var secondTableView: UITableView!
    
    let dataProvider = DataProvider<Contact>(operationMode: .UI)
    
    let secondDataProvider = DataProvider<Contact>(operationMode: .UI)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.secondTableView.dataSource = self
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
        
        if tableView == self.secondTableView {
            
            return secondDataProvider.fetchResultController.sections?[section].objects?.count ?? 0
        }
        
        return dataProvider.fetchResultController.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.secondTableView {
            
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "contactCell")
            
            let contact = self.secondDataProvider.fetchResultController.object(at: indexPath)
            
            cell.textLabel?.text = contact.name
            cell.detailTextLabel?.text = contact.number
            
            return cell
        }
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "contactCell")
        
        let contact = dataProvider.fetchResultController.object(at: indexPath)
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.number
        
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let contact = dataProvider.fetchResultController.object(at: indexPath)
            dataProvider.delete(item: contact, completion: { (success) in
                
                if success {
                    
                    try? self.dataProvider.fetchResultController.performFetch()
                    tableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CreatePresenter.present(viewController: self) { (name, number) in
            
            let contact = self.dataProvider.fetchResultController.object(at: indexPath)
            contact.name = name
            contact.number = number
            
            try? contact.managedObjectContext!.save()
            try? self.dataProvider.fetchResultController.performFetch()
            tableView.reloadData()
        }
    }
}

