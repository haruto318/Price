//
//  HomeViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    let electronicDict = ["television": "eogw", "speaker": "wega", "iphone": "wega"]
    let clothesDict = ["tshirt": "", "longSleeveTshirt": "", "sweats": ""]
    let cosmeticDict = ["faceWash": "", "perfume": "", "cleansingOil": ""]
    
    @IBOutlet weak var electronicCollectionView: UICollectionView!
    @IBOutlet var clothesCollectionView: UICollectionView!
    @IBOutlet var cosmeticCollectionView: UICollectionView!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var valueField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueField.layer.borderColor = UIColor.clear.cgColor
        valueField.layer.borderWidth = 1.0
        valueField.layer.cornerRadius = 22.5
        valueField.clipsToBounds = true
        
        print(electronicDict.count)
        
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
            return cell
        } else if collectionView == clothesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clothesCell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 22.5
            return cell
        } else if collectionView == cosmeticCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cosmeticCell", for: indexPath)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 22.5
            return cell
        }
        
        return UICollectionViewCell()
    }

}
