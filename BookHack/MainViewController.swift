//
//  MainViewController.swift
//  BookHack
//
//  Created by E on 4/1/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var previewCollection: UICollectionView!
    var books = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
