//
//  BookDetailViewController.swift
//  BookHack
//
//  Created by E on 4/2/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var pri: UILabel!
    @IBOutlet weak var condi: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var tit: UILabel!
    
    
    func feed(withurl:String!,title:String!,auth:String!,condition:String!,price:String) {
        
        cover.sd_setImage(with: URL(string: withurl) , placeholderImage: UIImage(named: ""))
        tit.text = title
        author.text = auth
        condi.text = condition
        pri.text = price
    }
    
        
    override func viewDidLoad() {
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
