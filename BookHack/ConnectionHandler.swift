//
//  ConnectionHandler.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class ConnectionHandler : NSObject,NSFetchedResultsControllerDelegate
{
    // MARK: Authentication
    
    static let sharedInstance = ConnectionHandler(maketype: "Book")
    
    var table : MSTable?
    var store : MSCoreDataStore?
    static var dataType:String!
    
    // If using a SAS token, fill it in here.  If using Shared Key access, comment out the following line.
    var containerURL = "https://bookhackstorage.blob.core.windows.net/hellobook?st=2017-04-01T18%3A29%3A00Z&se=2017-04-02T18%3A29%3A00Z&sp=rwdl&sv=2015-12-11&sr=c&sig=cBqvsllgXYIWQVE55Ss0Aa9hDHZlBC1JQV5kl9jXYs4%3D"
    var usingSAS = true
    var blobs = [AZSCloudBlob]()
    var container : AZSCloudBlobContainer?
    var continuationToken : AZSContinuationToken?
    
    init(maketype:String) {
        super.init()
        
        var error: NSError?
        self.container = AZSCloudBlobContainer(url: NSURL(string: containerURL)! as URL, error: &error)
        self.continuationToken = nil
        
        ConnectionHandler.dataType = maketype
        self.establishConnection()

}
    
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ConnectionHandler.dataType)
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        
        // show only non-completed items
        fetchRequest.predicate = NSPredicate(format: "deleted != true")
        
        // sort by item text
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Note: if storing a lot of data, you should specify a cache for the last parameter
        // for more information, see Apple's documentation: http://go.microsoft.com/fwlink/?LinkId=524591&clcid=0x409
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        resultsController.delegate = self;
        
        return resultsController
    }()
    
    
    func uploadBlob() {
        let blob = container!.blockBlobReference(fromName: "Test")
        
        // Use another method for pictures
        blob.upload(fromText: "",  completionHandler: { (error: Error?) -> Void in
            // Reload
        })
    }
    
    func uploadBookPicture(_ picture: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        let blob = container!.blockBlobReference(fromName: "bookCover")
        
        let imageData = UIImagePNGRepresentation(picture) as Data!
        
        // Use another method for pictures
        blob.upload(from: imageData!) { (error: Error?) in
            if error != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getBlobList() {
        container!.listBlobsSegmented(with: nil, prefix: nil, useFlatBlobListing: true, blobListingDetails: [], maxResults: 50) { (error : Error?, results : AZSBlobResultSegment?) -> Void in
            
            self.blobs = [AZSCloudBlob]()
            
            for blob in results!.blobs!
            {
                self.blobs.append(blob as! AZSCloudBlob)
                print(blob)
            }
            
            self.continuationToken = results!.continuationToken
            //self.tableView.performSelectorOnMainThread("reloadData", withObject: nil, waitUntilDone: false)
        }
    }

    
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
        
        let client = MSClient(applicationURLString: "https://bookhack.azurewebsites.net")
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        store = MSCoreDataStore(managedObjectContext: managedObjectContext)
        client.syncContext = MSSyncContext(delegate: nil, dataSource: store, callback: nil)
        table = client.table(withName: ConnectionHandler.dataType)
    }
    
    
    func addElement(Object:Any)
    {
        
        if let bookObj = Object as? Book {
            
            let itemToInsert = ["bookname": bookObj.name, "author": bookObj.author, "ISBN": bookObj.ISBN, "url": bookObj.url] as [AnyHashable : Any]
            
            self.table!.insert(itemToInsert, completion: { (item, error) in
                if error != nil {
                    print("Error: " + (error! as NSError).description)
                }
            })
            
        }
    }
    
    func getArrayOf(completion: @escaping (_ success: Bool, _ items: [Dictionary<String,Any>]) -> Void)
    {
        
        var Arr = [Dictionary<String,Any>]()
        
        
        table?.read{ (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    Arr.append(item as! [String : Any])
                }
                completion(true, Arr)
            }
        }
        
        print("---------------") 
    }
}
