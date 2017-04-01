//
//  LoginViewController.swift
//  BookHack
//
//  Created by Andrea Vitek on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func loginAndGetData() {
        guard let client = self.table?.client, client.currentUser == nil else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.todoTableViewController = self
        
        let loginBlock: MSClientLoginBlock = {(user, error) -> Void in
            if (error != nil) {
                print("Error: \(error!.localizedDescription)")
            }
            else {
                client.currentUser = user
                print("User logged in: \(user!.userId!)")
            }
        }
        
        client.login(withProvider:"google", urlScheme: "appname", controller: self, animated: true, completion: loginBlock)
        
    }
    
}
