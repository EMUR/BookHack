//
//  LoginViewController.swift
//  BookHack
//
//  Created by E on 4/2/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let client = ConnectionHandler.sharedInstance.table?.client, client.currentUser == nil else {
            return
        }
        
        let loginBlock: MSClientLoginBlock = {(user, error) -> Void in
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
            }
            else {
                client.currentUser = user
                print("User logged in: \(user?.userId)")
                self.performSegue(withIdentifier: "loggedIn", sender: nil)
                
            }
        }
        
        client.login(withProvider:"facebook", urlScheme: "bookhack", controller: self, animated: true, completion: loginBlock)
        
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
