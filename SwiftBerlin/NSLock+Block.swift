//
//  NSLock+Block.swift
//  SwiftBerlin
//
//  Created by Arash Kashi on 3/24/17.
//  Copyright © 2017 Arash Kashi. All rights reserved.
//

import Foundation


extension NSLock {
    
    func withCriticalScope<T>(_ block: (Void) -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}
