//
//  CollectionViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 6/25/24.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var words = ["one","two","three","four","five","six","seven", "eight"]
    
    @IBOutlet weak var collectionCell: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
    

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("jjjjjjjj    \(words.count)")
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as! CollectionViewCell
        
        let imageName = words[indexPath.item]
        cell.myimage.image = UIImage(named: imageName)
        print(imageName)
        return cell
    }
}


