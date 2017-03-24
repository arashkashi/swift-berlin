//
//  CoreStorable.swift
//  CoreStore
//
//  Created by Arash Kashi on 12/13/16.
//  Copyright © 2016 Arash K. All rights reserved.
//

import Foundation
import CoreData



protocol CoreStorable {
    
    associatedtype T: NSManagedObject
    
    static var metaInfo: ResourceMetaInfo { get }
    
    static var fetchRequestWithDescriptor: NSFetchRequest<T> { get }
    
    static var fetchAllRequest: NSFetchRequest<T> { get }
}


extension CoreStorable where T: NSManagedObject {
    
    static var fetchAllRequest: NSFetchRequest<T> {
        
        return NSFetchRequest<T>(entityName: Self.metaInfo.entityName)
    }
}


