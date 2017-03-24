//
//  DataProvider.swift
//  CoreStore
//
//  Created by Arash K. on 2016-11-19.
//  Copyright © 2016 Arash K. All rights reserved.
//

import Foundation
import CoreData



public enum DataProviderOperationMode {
    
    case UI, Data
}



class DataProvider<T: CoreStorable & NSFetchRequestResult>: NSObject {
    
    private(set)    var mainManagedContext:         NSManagedObjectContext!
    private(set)    var fetchResultController:      NSFetchedResultsController<T>!
    private         var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        
        return PersistentStoresCoordinatorManager.sharedIntance.persistenceStoreCoordinatorFor(modelClass: T.self)
    }
    
    private         var mode: DataProviderOperationMode
    
    fileprivate let initLock = NSLock()
    
    weak var subscriber: NSFetchedResultsControllerDelegate?
    
    // MARK: API
    
    /**
     Create a new managed object which is not saved to data base
     
     - Parameter setupBlock: the block to setup the properties of the new object
     - Parameter completion: block than returns the newly created object
     */
    
    func create(setupBlock: @escaping (T) -> Void,
                completion: @escaping (T) -> Void)  {
        
        mainManagedContext.perform {
            
            let newItem = NSEntityDescription.insertNewObject(forEntityName: T.metaInfo.entityName,
                                                              into: self.mainManagedContext)
            
            setupBlock(newItem as! T)
            completion(newItem as! T)
        }
    }
    
    /**
     Insert a new managed object
     
     - Parameter beforeSave: the operation to be done on the managed object
     before saving, return the success Bool flag
     - Parameter completion: say if the completion has been successfull
     */
    
    func insert(beforeSave: @escaping (T?) -> Bool,
                completion: ((T?) -> Void)? = nil) {
        
        mainManagedContext.perform {
            
            let newItem = NSEntityDescription.insertNewObject(forEntityName: T.metaInfo.entityName,
                                                              into: self.mainManagedContext)
            
            if !beforeSave(newItem as? T) { completion?(nil)  }
            
            do {
                try self.mainManagedContext.save()
                completion?(newItem as? T)
            }
            catch let myError {
                print("Here is error: \(myError)")
                completion?(nil)
            }
        }
    }
    
    func fetch<FetchedType: NSManagedObject>(fetchRequest: NSFetchRequest<FetchedType>, completion: @escaping ([FetchedType]?) -> Void)  {
        
        mainManagedContext.perform {
            
            guard let result = try? self.mainManagedContext.fetch(fetchRequest) else { completion(nil); return }
            let castedResult = result.flatMap { $0 }
            
            completion(castedResult)
        }
    }
    
    func delete(item: NSManagedObject, completion: @escaping (Bool) -> ()) {
        
        mainManagedContext.perform {
            
            self.mainManagedContext.delete(item)
            do {
                try self.mainManagedContext.save()
                completion(true)
            }
            catch {
                completion(false)
            }
        }
    }
    
    func delelteAll() {
        
        let fetchRequest = NSFetchRequest<T>(entityName: T.metaInfo.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        let _ = try? self.persistentStoreCoordinator.execute(batchDeleteRequest,
                                                             with: mainManagedContext)
    }
    
    // MARK: Subscription
    
    func subscribe(object: NSFetchedResultsControllerDelegate,
                   fetchRequest: NSFetchRequest<T.T> = T.fetchRequestWithDescriptor) throws {
        
        subscriber = object
        fetchResultController =
            setupFetchResultController(moc: mainManagedContext, fetchRequest: fetchRequest)
        fetchResultController.delegate = object
        try fetchResultController.performFetch()
    }
    
    // MARK: Initiations
    
    init(operationMode: DataProviderOperationMode
        , mergePolicyType: NSMergePolicyType = .errorMergePolicyType) {
        
        mode = operationMode
        
        super.init()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil,
                                               queue: nil,
                                               using: { note in
                                                
                                                if let sourceContext = note.object as? NSManagedObjectContext,
                                                    sourceContext != self.mainManagedContext{
                                                    
                                                    self.mainManagedContext.perform {
                                                        
                                                        self.mainManagedContext.mergeChanges(fromContextDidSave: note)
                                                    }
                                                }
        })
        
        initLock.withCriticalScope { (Void) -> Void in
            
            mainManagedContext =
                setupManagedObjectContext(psc: persistentStoreCoordinator,
                                          operationMode: operationMode)
            
            fetchResultController =
                setupFetchResultController(moc: mainManagedContext)
            
            mainManagedContext.mergePolicy = NSMergePolicy(merge: mergePolicyType)
        }
    }
    
    deinit { }
    
    private func setupFetchResultController(moc: NSManagedObjectContext,
                                            fetchRequest: NSFetchRequest<T.T> = T.fetchRequestWithDescriptor) -> NSFetchedResultsController<T>? {
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: moc,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return fetchedResultsController as? NSFetchedResultsController<T>
    }
    
    private func setupManagedObjectContext(psc: NSPersistentStoreCoordinator,
                                           operationMode: DataProviderOperationMode = .Data) -> NSManagedObjectContext {
        
        var managedObjectContext: NSManagedObjectContext
        
        switch operationMode
        {
        case .UI:   managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        case .Data: managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        }
        
        managedObjectContext.persistentStoreCoordinator = psc
        
        return managedObjectContext
    }
}




