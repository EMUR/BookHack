//
//  SearchViewController.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewWillLayoutSubviews() {
        searchField.alpha = 0.0
        searchButton.alpha = 0.0
//        self.searchField.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.searchField.alpha = 1.0
            self.searchField.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height * 0.009)
            self.searchButton.alpha = 1.0

        }) { (done:Bool) in
            self.searchField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchField: UITextField!

    @IBOutlet weak var resultsTable: UITableView!
    
    var results = [Dictionary<String, Any>]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        searchField.layer.shadowColor = UIColor.black.cgColor
        searchField.layer.shadowOpacity = 0.4
        searchField.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        searchField.layer.shadowRadius = 3
        
        searchField.borderStyle = UITextBorderStyle.none
        
        searchField.backgroundColor = UIColor(colorLiteralRed: Float(253), green: Float(253), blue: Float(253), alpha: 1.0)
        
        
    
        resultsTable.delegate = self
        resultsTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(results.count)

        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookTableViewCell
        
        print("\(results[indexPath.row]["bookname"] as? String)")
        
        cell.coverImg.sd_setImage(with: URL(string: results[indexPath.row]["url"] as! String) , placeholderImage: UIImage(named: ""))
        
    
        cell.name.text = results[indexPath.row]["bookname"] as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func preformSearch(_ sender: Any) {
        ConnectionHandler.sharedInstance.findBooks(nameOfBooks: searchField.text) { (good:Bool, ar:[Dictionary<String, Any>]) in
            
            
            if(good)
            {

                for i in ar
                {
                    self.results.append(i)
                }
            }
        }
        
        self.resultsTable.reloadData()
        self.resultsTable.endUpdates()
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
