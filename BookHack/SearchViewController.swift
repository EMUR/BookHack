//
//  SearchViewController.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notFound: UILabel!
    @IBOutlet weak var loadingIn: UIActivityIndicatorView!
    
    override func viewWillLayoutSubviews() {
        searchField.alpha = 0.0
        searchButton.alpha = 0.0
        self.searchField.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        searchField.leftView = l;
        
        searchField.leftViewMode = UITextFieldViewMode.always
        searchField.contentVerticalAlignment = UIControlContentVerticalAlignment.center;

//        self.searchField.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.searchField.alpha = 1.0
            self.searchButton.alpha = 1.0
            self.searchField.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)


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
        
        searchField.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        
    
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
            
            self.view.viewWithTag(2)?.isHidden = false
            
            self.notFound.isHidden = true
            self.loadingIn.isHidden = false

            
            self.results.removeAll()
            
            if(good)
            {

                for i in ar
                {
                    self.results.append(i)
                }
            }
            
            DispatchQueue.main.async {
                
                if(self.results.count == 0)
                {
                    self.view.viewWithTag(2)!.isHidden = false
                    self.notFound.isHidden = false

                }else
                {
                self.view.viewWithTag(2)!.isHidden = true
                }
                
                self.loadingIn.isHidden = true
                    


                self.resultsTable.reloadData()
                self.resultsTable.endUpdates()
            }
            
        }

    }
    @IBAction func dissmiss(_ sender: Any) {
        self.dismiss(animated: false) { 
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookDetailViewController()
        vc.feed(withurl: results[indexPath.row]["url"] as! String, title: results[indexPath.row]["bookname"] as! String, auth: results[indexPath.row]["author"] as! String, condition: results[indexPath.row]["condition"] as! String, price:results[indexPath.row]["price"] as! String)
        performSegue(withIdentifier: "detail", sender: self)
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
