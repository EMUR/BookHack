//
//  ConnectionHandler.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit


var table : MSSyncTable?
var store : MSCoreDataStore?

class ConnectionHandler : NSObject,NSFetchedResultsControllerDelegate
{
    
    static var dataType:String! = ""
    
    init(maketype:String) {
        super.init()
        ConnectionHandler.dataType = maketype
        self.establishConnection()
    }
    
    
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ConnectionHandler.dataType)
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        
        // show only non-completed items
        fetchRequest.predicate = NSPredicate(format: "complete != true")
        
        // sort by item text
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Note: if storing a lot of data, you should specify a cache for the last parameter
        // for more information, see Apple's documentation: http://go.microsoft.com/fwlink/?LinkId=524591&clcid=0x409
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        resultsController.delegate = self;
        
        return resultsController
    }()
    
    func establishConnection()
    {
        
        var error : NSError? = nil
        do {
            try fetchedResultController.performFetch()
        } catch let error1 as NSError {
            error = error1
            print("Unresolved error \(String(describing: error)), \(String(describing: error?.userInfo))")
            abort()
        }
    }
    
    
    func addElement(Object:Any)
    {
        print("Added")
    }

    
    
    func getArrayOf(completion: @escaping (_ success: Bool, _ items: [Dictionary<AnyHashable,Any>]) -> Void)
    {
        
        var Arr = [Dictionary<AnyHashable,Any>]()
        
    
        let client = MSClient(applicationURLString: "https://bookhack.azurewebsites.net")
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        store = MSCoreDataStore(managedObjectContext: managedObjectContext)
        client.syncContext = MSSyncContext(delegate: nil, dataSource: store, callback: nil)
        table = client.syncTable(withName: ConnectionHandler.dataType)
        
        table?.read{ (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    Arr.append(item)
                }
                completion(true, Arr)
            }
            
        }
        
    }
}
