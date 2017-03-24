//
//  Contact.swift
//  SwiftBerlin
//
//  Created by Arash Kashi on 3/24/17.
//  Copyright © 2017 Arash Kashi. All rights reserved.
//

import Foundation
import CoreData



struct ContactMetaInfo: ResourceMetaInfo {
    
    /// The name of the momd file.
    var coreStoreModelName      : String {
        
        return "Contact"
    }
    
    /// The name of the sqlite file, e.g. "Contact.sqlite"
    var coreStoreSQLiteFilename : String {
        
        return "Contact.sqlite"
    }
    
    /// The name of the entity in the model file, e.g. Contact
    var entityName: String {
        
        return "Contact"
    }
}



extension Contact: CoreStorable {
    
    
    static var metaInfo: ResourceMetaInfo {
        
        return ContactMetaInfo()
    }
    
    static var fetchRequestWithDescriptor: NSFetchRequest<Contact> {
        
        let request =  Contact.fetchAllRequest
        request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]

        return request
    }
}
