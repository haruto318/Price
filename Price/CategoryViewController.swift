//
//  CategoryViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/07/06.
//

import UIKit
import OrderedCollections

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet var categoryLabel: UILabel!
    
    var selectedCategoryDict: OrderedDictionary<String,UIImage?>?
    var selectedCategoryName: String = ""
    var cellSize: Int = 0
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet var valueField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = selectedCategoryName
        
        valueField.layer.borderColor = UIColor.clear.cgColor
        valueField.layer.borderWidth = 1.0
        valueField.layer.cornerRadius = 22.5
        valueField.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // vertical scroll
        let size = categoryCollectionView.frame.width
        layout.itemSize = CGSize(width: size / 2 / 1.2, height: size / 2 * 1.25)
        layout.sectionInset = UIEdgeInsets(top: 10,
                                                   left: 20,
                                                   bottom: 30,
                                                   right: 20)
        categoryCollectionView.collectionViewLayout = layout
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
