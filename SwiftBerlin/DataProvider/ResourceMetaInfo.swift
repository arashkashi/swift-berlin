//
//  ResourceMetaInfo.swift
//  CoreStore
//
//  Created by Arash Kashi on 11/21/16.
//  Copyright © 2016 Arash K. All rights reserved.
//

import Foundation



protocol ResourceMetaInfo {
    
    /// The name of the momd file.
    var coreStoreModelName      : String { get }
    
    /// The name of the sqlite file, e.g. "Contact.sqlite"
    var coreStoreSQLiteFilename : String { get }
    
    /// The name of the entity in the model file, e.g. Contact
    var entityName: String { get }
}
