//
//  HomeViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit
import OrderedCollections

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    let electronicDict: OrderedDictionary = ["TV": UIImage(named: "tv"), "Speaker": UIImage(named: "speaker"), "headphone": UIImage(named: "headphone"), "laptop": UIImage(named: "laptop")]
    let clothesDict: OrderedDictionary = ["T-Shirt": UIImage(named: "shirt"), "Shoes": UIImage(named: "shoes"), "Sweater": UIImage(named: "sweater"), "Long_Shirt": UIImage(named: "longShirt")]
    let cosmeticDict: OrderedDictionary = ["Body_Oil": UIImage(named: "body_oil"), "Lipstick": UIImage(named: "lipstick"), "Mascara": UIImage(named: "mascara")]
    
    var selectedCategoryDict: OrderedDictionary<String,UIImage?>? = nil
    var selectedCategoryName: String = ""
    
    @IBOutlet weak var electronicCollectionView: UICollectionView!
    @IBOutlet var clothesCollectionView: UICollectionView!
    @IBOutlet var cosmeticCollectionView: UICollectionView!
    
    @IBOutlet var electronicCellImage: UIImage!
    
    @IBOutlet var valueField: UITextField!
    var keyword: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueField.layer.borderColor = UIColor.clear.cgColor
        valueField.layer.borderWidth = 1.0
        valueField.layer.cornerRadius = 22.5
        valueField.clipsToBounds = true
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        valueField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 横スクロール
        let size = electronicCollectionView.frame.height
        layout.itemSize = CGSize(width: size / 1.5, height: size)
        electronicCollectionView.collectionViewLayout = layout
        clothesCollectionView.collectionViewLayout = layout
        cosmeticCollectionView.collectionViewLayout = layout
        
//        scrollView.contentSize = contentsView.frame.size
//        scrollView.flashScrollIndicators()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == electronicCollectionView {
            return electronicDict.count
        } else if collectionView == clothesCollectionView {
            return clothesDict.count
        } else if collectionView == cosmeticCollectionView {
            return cosmeticDict.count
        }
        return 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == electronicCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "electronicCell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 22.5
            let imageView = cell.contentView.viewWithTag(1) as! UIImageView
            imageView.image = electronicDict.elements[indexPath.row].value
            return cell
        } else if collectionView == clothesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clothesCell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 22.5
            let imageView = cell.contentView.viewWithTag(1) as! UIImageView
            imageView.image = clothesDict.elements[indexPath.row].value
            return cell
        } else if collectionView == cosmeticCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cosmeticCell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 22.5
            let imageView = cell.contentView.viewWithTag(1) as! UIImageView
            imageView.image = cosmeticDict.elements[indexPath.row].value
            return cell
        }
        return UICollectionViewCell()
    }
    
    @IBAction func electronicButton(){
        selectedCategoryDict = electronicDict
        selectedCategoryName = "ELECTRONICS"
        if selectedCategoryDict != nil && selectedCategoryName != ""{
            self.performSegue(withIdentifier: "visitCategoryView", sender: nil)
        }
    }
    
    @IBAction func clotheButton(){
        selectedCategoryDict = clothesDict
        selectedCategoryName = "CLOTHES"
        if selectedCategoryDict != nil && selectedCategoryName != ""{
            self.performSegue(withIdentifier: "visitCategoryView", sender: nil)
        }
    }
    
    @IBAction func cosmeticButton(){
        selectedCategoryDict = cosmeticDict
        selectedCategoryName = "COSMETICS"
        if selectedCategoryDict != nil && selectedCategoryName != ""{
            self.performSegue(withIdentifier: "visitCategoryView", sender: nil)
        }
    }
    
    @IBAction func searchStart(){
        if valueField.text != nil{
            keyword = valueField.text!
            self.performSegue(withIdentifier: "searchStartView", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "visitCategoryView" {
            let CategoryViewController = segue.destination as! CategoryViewController
            CategoryViewController.selectedCategoryDict = self.selectedCategoryDict!
            CategoryViewController.selectedCategoryName = self.selectedCategoryName
        }
        else if segue.identifier == "searchStartView" {
            let ComparePriceViewController = segue.destination as! ComparePriceViewController
            ComparePriceViewController.keyword = self.keyword
        }
    }

}
