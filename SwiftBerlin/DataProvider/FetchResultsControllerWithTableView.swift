//
//  FetchResultsControllerWithTableView.swift
//  CoreStore
//
//  Created by Arash Kashi on 12/23/16.
//  Copyright © 2016 Arash K. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class FetchResultsControllerWithTableView<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    private var tableView: UITableView
    private var fetchResultsController: NSFetchedResultsController<T>
    
    init(tableView: UITableView, fetchController: NSFetchedResultsController<T>) {
        
        self.tableView = tableView
        self.fetchResultsController = fetchController
        
        super.init()
        
        self.fetchResultsController.delegate = self
        
        DispatchQueue.main.async {
        
            try? self.fetchResultsController.performFetch()
            self.tableView.reloadData()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        assert(Thread.isMainThread)
        
        switch type {
            
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            break
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            break
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
            break
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .automatic)
            break
        }
        
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        assert(Thread.isMainThread)
        
        self.tableView.reloadData()
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        assert(Thread.isMainThread)
        
        self.tableView.beginUpdates()
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        assert(Thread.isMainThread)
        
        self.tableView.endUpdates()
        
    }
}
