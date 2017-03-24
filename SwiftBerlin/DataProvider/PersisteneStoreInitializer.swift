//
//  CoreDataInitializer.swift
//  CoreStore
//
//  Created by Arash K. on 2016-11-20.
//  Copyright © 2016 Arash K. All rights reserved.
//

import Foundation
import CoreData



/**
 # Persistence Store Initializer
 
 ## Reponsibilities
 
 - Setup persistence controller
 - Setup managed context
 
 */

class PersisteneStoreInitializer {
    
    /**
     Setup Persistence Store Coordinator.
     
     - Parameter filename:   e.g. "Contacts.sqlite"
     - Parameter resourceDataModelName: The number of times to repeat `str`.
     
     - Throws: 'Nothing'.
     
     - Returns: A new NSPersistentStoreCoordinator.
     */
    
    func setupPersistenceStoreCoordinator(filename: String
        , resourceDataModelName: String) -> NSPersistentStoreCoordinator {
        
        guard let modelURL =
            Bundle.main.url(forResource: resourceDataModelName,
                            withExtension: "momd") else {
                                
                                fatalError()
        }
        
        guard let managedObjectModel =
            NSManagedObjectModel(contentsOf: modelURL) else {
                
                fatalError()
        }
        
        let persistenceStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let urls = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        let docURL = urls[urls.endIndex-1]
        
        let storeURL = docURL.appendingPathComponent(filename)
        
        do {
            try persistenceStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                               configurationName: nil,
                                                               at: storeURL,
                                                               options: nil)
        } catch {
            
            fatalError("Error migrating store: \(error)")
        }
        
        return persistenceStoreCoordinator
    }
}
