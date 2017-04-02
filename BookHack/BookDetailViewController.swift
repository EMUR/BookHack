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
    @IBOutlet weak var seller: UILabel!
    var imgUrl:String!
    var au:String!
    var imtit:String!
    var prio:String!
    var Con:String!
    var sell:String!
    
    
    func feed(withurl:String!,title:String!,auth:String!,condition:String!,price:Double) {
        
        imgUrl = withurl
        imtit = title
        au = auth
        Con = condition
       prio = "$\(price)"
    }
    
    
    func setUp()
    {
        cover.sd_setImage(with: URL(string: imgUrl) , placeholderImage: UIImage(named: ""))
        tit.text = imtit
        author.text = au
        condi.text = Con
        pri.text = prio

    }
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        setUp()
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
