//
//  ComparePriceViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit

class ComparePriceViewController: UIViewController {
    
    var keyword: String = ""
    
    @IBOutlet weak var searchedCollectionView: UICollectionView!
    
    @IBOutlet var valueField: UITextField!
    @IBOutlet var keywordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        keywordLabel.text = keyword
        
        valueField.layer.borderColor = UIColor.clear.cgColor
        valueField.layer.borderWidth = 1.0
        valueField.layer.cornerRadius = 10
        valueField.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // vertical scroll
        let size = searchedCollectionView.frame.width
        layout.itemSize = CGSize(width: size / 2 / 1.2, height: size / 2 * 1.25)
        layout.sectionInset = UIEdgeInsets(top: 10,
                                                   left: 20,
                                                   bottom: 30,
                                                   right: 20)
        searchedCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCategoryDict!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 22.5
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = selectedCategoryDict!.elements[indexPath.row].value
        return cell
    }

}
