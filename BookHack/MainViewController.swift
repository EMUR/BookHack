//
//  MainViewController.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let book = ConnectionHandler(maketype: "Book")
        
    
        book.getArrayOf { (resul: Bool, array: [Dictionary<String, Any>]) in
            for i in array
            {
                print(i["bookname"] as! String)
            }
        }
//
//        book.addElement(Object: Book(names: "Calc", auth: "Me", ISBNs: 123, urls: "www.google.com", created: Date()))
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
