//
//  CreatePresenter.swift
//  SwiftBerlin
//
//  Created by Arash Kashi on 3/24/17.
//  Copyright © 2017 Arash Kashi. All rights reserved.
//

import Foundation
import UIKit



class CreatePresenter {
    
    typealias ResultBlock = ((name: String, number: String)) -> Void
    
    static func present(viewController: UIViewController, resultBlock: @escaping ResultBlock) {
        
        let alertController = UIAlertController(title: "Enter", message: "", preferredStyle: .alert)

        
        let enterAction = UIAlertAction(title: "Enter", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let name    = alertController.textFields?[0].text ?? "No name entered"
            let number  = alertController.textFields?[1].text ?? "No number entered"
            
            resultBlock((name, number))
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { textField in
            
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { textField in
            
            textField.placeholder = "Enter Number"
        }
        
        alertController.addAction(enterAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}


class SearchDelegate: NSObject, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        onChangeBlock?(searchText)
    }
    
    var onChangeBlock: ((String) -> Void)?
}


extension UISearchBar {
    
    static func addToHeaderOf(tableview: UITableView
        , searchDelegate: SearchDelegate
        , onSearchChange: @escaping (String) -> Void) {
        
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 105, height: 45))

        searchDelegate.onChangeBlock = onSearchChange
    
        bar.delegate = searchDelegate
        
        tableview.tableHeaderView = bar
    }
}

