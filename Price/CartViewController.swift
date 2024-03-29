//
//  CartViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/07/12.
//

import UIKit
import RealmSwift
import ContextMenuSwift

class CartViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate{
    

    @IBOutlet weak var cartCollectionView: UICollectionView!
    
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var totalProductLabel: UILabel!
    
    let realm = try! Realm()
    var products: [ProductInfo] = []
    
    var getUrl: String = ""

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

        // additional setup after loading the view.
        products = readProducts()

        
        //長押し時の判定
        // UILongPressGestureRecognizer宣言
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                                   action: #selector(ComparePriceViewController.cellLongPressed(_ :)))

        // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
        longPressRecognizer.delegate = self

        // tableViewにrecognizerを設定
        // Add long press gesture recognizer to the collection view cells
        cartCollectionView.addGestureRecognizer(longPressRecognizer)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // total price and product count variables for display
        var totalPrice: Float = 0
        var totalProduct: Int = 0
        
        for product in products {
            print(product.price)
            totalPrice += Float(product.price)! * Float(product.num)
            totalProduct += product.num
        }
        
        totalPriceLabel.text = String(totalPrice) + " yen"
        totalProductLabel.text = "Total " + String(totalProduct) + " Items"
        
        // Reload collection view data
        cartCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath)
        
        // Product image
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
        productPriceLabel.text = products[indexPath.row].price + "yen"
        let productaNumLabel = cell.contentView.viewWithTag(4) as! UILabel
        productaNumLabel.text = String(products[indexPath.row].num)
        let container = cell.contentView.viewWithTag(5) as! UIView
        container.layer.cornerRadius = 30
        container.layer.borderWidth = 2.0
        container.layer.borderColor = UIColor.gray.cgColor
//        plusBtn.addTarget(self,
//                          action: #selector(self.delData(sender: , url: products[indexPath.row].url)),
//                       for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                              didSelectItemAt indexPath: IndexPath) {
    
        // Open the link of the selected product
        guard let url = URL(string: products[indexPath.row].url) else { return }
        UIApplication.shared.open(url)
    }
    
    // Read products from Realm database
    func readProducts() -> [ProductInfo]{
        return Array(realm.objects(ProductInfo.self))
    }
    

//    func deleteRealm(url: String){
//        let productInfo: ProductInfo! = realm.objects(ProductInfo.self).filter("url == %@", url).first
//
//        if productInfo != nil {
//            try! realm.write {
//                realm.delete(products)
//            }
//        }
//    }

}



// MARK: ContextMenuDelegate
extension CartViewController: ContextMenuDelegate {
    
    func contextMenuDidSelect(_ contextMenu: ContextMenu,
                              cell: ContextMenuCell,
                              targetedView: UIView,
                              didSelect item: ContextMenuItem,
                              forRowAt index: Int) -> Bool {
        
        
        
        switch index {
            case 0:
                //0番目のセル(1番上のメニューがタップされると実行されます)
                //この例では編集メニューに設定してあります
                print(getUrl)
                let url = URL(string: getUrl)
                // Open Link is pressed
                UIApplication.shared.open(url!)
            
            case 1:
                //when tap delete button
//                deleteRealm(url: getUrl)
            
            default:
                // Other cell is pressed
                //ここはその他のセルがタップされた際に実行されます
                break
            }
            
            //最後にbool値を返します
            return true

    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu,
                                cell: ContextMenuCell,
                                targetedView: UIView,
                                didSelect item: ContextMenuItem,
                                forRowAt index: Int) {
    }
    

    //コンテキストメニューが表示されたら呼ばれる
    // Context menu appearance and disappearance handlers
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("コンテキストメニューが表示された")
    }
    
    /**
     コンテキストメニューが消えたら呼ばれる
     */
    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
        print("コンテキストメニューが消えた")
    }
    
    /// セルが長押しした際に呼ばれるメソッド
    /// Long press gesture handler
    @objc func cellLongPressed(_ recognizer: UILongPressGestureRecognizer) {

        // Get indexPath for the pressed position
        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: cartCollectionView)
        // 押された位置に対応するindexPath
        let indexPath = cartCollectionView.indexPathForItem(at: point)
            
        if indexPath == nil {  //indexPathがなかったら
                
            return  //すぐに返り、後の処理はしない
                
        } else if recognizer.state == UIGestureRecognizer.State.began  {
            // 長押しされた場合の処理
            
            // Set the URL of the selected product
            getUrl = products[indexPath!.row].url
//          let addName = productNames[indexPath?.row] /// 本番用
//          let addPrice = "USD " + productPrice[indexPath?.row] /// 本番用
//          let addUrl = URL(string: productImageUrl[indexPath?.row]) /// 本番用
                
            //コンテキストメニューの内容を作成します
            // Create context menu items
            let add = ContextMenuItemWithImage(title: "Open Link", image: UIImage(systemName: "cart")!)
            let delete = ContextMenuItemWithImage(title: "Delete", image: UIImage(systemName: "trash")!)
                
            //コンテキストメニューに表示するアイテムを決定します
            CM.items = [add, delete]
            //表示します
            // Display context menu
            CM.showMenu(viewTargeted: cartCollectionView.cellForItem(at: indexPath!)!,
                        delegate: self,
                        animated: true)
                
        }
    }
    
}

