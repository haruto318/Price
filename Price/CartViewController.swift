//
//  CartViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/07/12.
//

import UIKit
import RealmSwift

class CartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var cartCollectionView: UICollectionView!
    
    let realm = try! Realm()
    var products: [ProductInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartCollectionView.dataSource = self
        cartCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // vertical scroll
        let size = cartCollectionView.frame.width
        layout.itemSize = CGSize(width: size, height: size / 2 * 0.75 )
        layout.sectionInset = UIEdgeInsets(top: 5,
                                                   left: 0,
                                                   bottom: 5,
                                                   right: 0)
        cartCollectionView.collectionViewLayout = layout

        // Do any additional setup after loading the view.
        products = readProducts()
        
        print(products[0])
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let url = URL(string: products[indexPath.row].imageUrl)
        DispatchQueue.global().async {
            do {
                let imgData = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: imgData)
                    cell.setNeedsLayout()
                }
            }catch let err {
                print("Error : (err.localizedDescription)")
            }
        }
        let productNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        productNameLabel.text = products[indexPath.row].name
        let productPriceLabel = cell.contentView.viewWithTag(3) as! UILabel
        productPriceLabel.text = "USD " + products[indexPath.row].price
        let productaNumLabel = cell.contentView.viewWithTag(4) as! UILabel
        productaNumLabel.text = String(products[indexPath.row].num)
        return cell
    }
    
    
    func readProducts() -> [ProductInfo]{
        return Array(realm.objects(ProductInfo.self))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
