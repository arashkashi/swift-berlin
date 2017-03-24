//
//  PersistentStoreCoordinatorManager.swift
//  CoreStore
//
//  Created by Arash Kashi on 12/21/16.
//  Copyright © 2016 Arash K. All rights reserved.
//

import Foundation
import CoreData



/**
 # PersistentStoresCoordinatorManager
 
 ## Reponsibilities
 
 - Holds a dictionary of entity names and their correspondinf persistent store coordinator
 - Provides with persistent store coordinator, when asked, initiates if does not have it
 locally stored in its dixtionary
 
 */
class PersistentStoresCoordinatorManager {
    
    private var storeCordinatorByEntityName: [String: NSPersistentStoreCoordinator] = [:]
    
    private let persisteneStoreInitializer: PersisteneStoreInitializer = PersisteneStoreInitializer()
    
    func persistenceStoreCoordinatorFor<T: CoreStorable>(modelClass: T.Type) -> NSPersistentStoreCoordinator {
        
        if let alreadyExistingCoordinator = storeCordinatorByEntityName[modelClass.metaInfo.coreStoreModelName] {
            
            return alreadyExistingCoordinator
        }
        
        let newCoordinator = persisteneStoreInitializer.setupPersistenceStoreCoordinator(filename: modelClass.metaInfo.coreStoreSQLiteFilename, resourceDataModelName: modelClass.metaInfo.coreStoreModelName)
        
        storeCordinatorByEntityName[modelClass.metaInfo.coreStoreModelName] = newCoordinator
        
        return newCoordinator
    }
    
    private init() {}
    
    static let sharedIntance: PersistentStoresCoordinatorManager = {
        
        return PersistentStoresCoordinatorManager()
    }()
}
