//
//  MainViewController.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var seachView: UITextField!
    
    
    @IBOutlet weak var previewCollection: UICollectionView!
    var books = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        seachView.layer.shadowColor = UIColor.black.cgColor
        seachView.layer.shadowOpacity = 0.4
        seachView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        seachView.layer.shadowRadius = 3

        //searchField.backgroundColor = UIColor(colorLiteralRed: Float(253), green: Float(253), blue: Float(253), alpha: 1.0)

        
        previewCollection.delegate = self
        previewCollection.dataSource = self
        
        let book = ConnectionHandler.sharedInstance
        
    
        book.getArrayOf { (resul: Bool, array: [Dictionary<String, Any>]) in
            for i in array
            {
                self.books.append(i)
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = previewCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!BookCollectionViewCell
        
        cell.CoverImg.sd_setImage(with: URL(string: books[indexPath.row]["url"] as! String) , placeholderImage: UIImage(named: ""))
        
        
    
        return cell
    }
    @IBAction func relaod(_ sender: Any) {
        
        previewCollection.reloadData()
        
    }
    @IBAction func doSearch(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
