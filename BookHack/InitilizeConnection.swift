////
////  InitilizeConnection.swift
////  BookHack
////
////  Created by E on 4/1/17.
////  Copyright © 2017 Microsoft. All rights reserved.
////
//
//import UIKit
//
//class InitilizeConnection: NSObject, NSFetchedResultsControllerDelegate {
//    static let sharedInstance = InitilizeConnection()
//    
//    var table : MSTable?
//    var store : MSCoreDataStore?
//    
//    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
//        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ConnectionHandler.dataType)
//        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
//        
//        // show only non-completed items
//        fetchRequest.predicate = NSPredicate(format: "deleted != true")
//        
//        // sort by item text
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
//        
//        // Note: if storing a lot of data, you should specify a cache for the last parameter
//        // for more information, see Apple's documentation: http://go.microsoft.com/fwlink/?LinkId=524591&clcid=0x409
//        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//        
//        resultsController.delegate = self;
//        
//        return resultsController
//    }()
//
//    func establishConnection()
//    {
//        var error : NSError? = nil
//        do {
//            try fetchedResultController.performFetch()
//        } catch let error1 as NSError {
//            error = error1
//            print("Unresolved error \(String(describing: error)), \(String(describing: error?.userInfo))")
//            abort()
//        }
//        
//        let client = MSClient(applicationURLString: "https://bookhack.azurewebsites.net")
//        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
//        store = MSCoreDataStore(managedObjectContext: managedObjectContext)
//        client.syncContext = MSSyncContext(delegate: nil, dataSource: store, callback: nil)
//        table = client.table(withName: ConnectionHandler.dataType)
//    }
//
//
//}
