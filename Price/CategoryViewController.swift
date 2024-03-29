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
    
    // Properties for category information
    var selectedCategoryDict: OrderedDictionary<String,UIImage?>?
    var selectedCategoryName: String = ""
    var cellSize: Int = 0
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // Outlet for the search text field
    @IBOutlet var valueField: UITextField!
    var keyword: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryLabel.text = selectedCategoryName
        
        valueField.layer.borderColor = UIColor.clear.cgColor
        valueField.layer.borderWidth = 1.0
        valueField.layer.cornerRadius = 22.5
        valueField.clipsToBounds = true
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        valueField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        
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
    
    // Action for starting the search
    @IBAction func searchStart(){
        if valueField.text != nil{
            keyword = valueField.text!
            if selectedCategoryDict != nil && selectedCategoryName != ""{
                self.performSegue(withIdentifier: "searchStartView", sender: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
