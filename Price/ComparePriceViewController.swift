//
//  ComparePriceViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit
import SkeletonView
import ContextMenuSwift
import RealmSwift
import OfflineData

class ComparePriceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{
    
    let realm = try! Realm()
    
    // API token and base URL
    let token = "JYYQLVJZXWIGERFAUHEYFUJSCKAMJKFZXJMBJHSQYHGQBZMHGDZDQRZKQTGHXNTU"
    let base = "https://api.priceapi.com/v2/jobs/"
    
    // Structs for API response parsing
    struct checkingRequest: Decodable{
        let job_id: String
        let status: String
        init() {
            job_id = ""
            status = ""
        }
    }
    
    struct initialRequestJSON: Decodable{ //struct for the initial JSON parsing
        let job_id: String
        let status: String
    }
    
    struct returnJSON: Decodable {
        let job_id: String
        let status: String
        var results: [Result]?
    }

    struct Result: Decodable {
        var content: Content?
    }
    
    struct Content: Codable{
        var search_results: [searchResults]?
    }
    
    struct searchResults: Codable {
        var url: String?
        var name: String?
        var min_price: String?
        var image_url: String?
    }
    
    var productNames: [String] = [] /// 本番
    var productUrl: [String] = [] /// 本番
    var productPrice: [String] = [] /// 本番
    var productImageUrl: [String] = [] /// 本番
    
    // Sample data from OfflineData
    let iphonePhysicalShopName: [String] = OfflineData.iphonePhysicalShopName
    let iphonePhysicalUrl: [String] = OfflineData.iphonePhysicalUrl
    let iphonePhysicalPrice: [String] = OfflineData.iphonePhysicalPrice
    let iphonePhysicalImageUrl: [String] = OfflineData.iphonePhysicalImageUrl
    let rolandPhysicalShopName: [String] = OfflineData.rolandPhysicalShopName
    let rolandPhysicalUrl: [String] = OfflineData.rolandPhysicalUrl
    let rolandPhysicalPrice: [String] = OfflineData.rolandPhysicalPrice
    let rolandPhysicalImageUrl: [String] = OfflineData.rolandPhysicalImageUrl
    
    let sampleName: [String] = OfflineData.sampleName
    let sampleUrl: [String] = OfflineData.sampleUrl
    let sampleImageUrl: [String] = OfflineData.sampleImageUrl
    
    // Keyword for initial API call
    var keyword: String = "iPhone 14"
    
    @IBOutlet weak var searchedCollectionView: UICollectionView!
    
    @IBOutlet var keywordLabel: UILabel!
    @IBOutlet var keywordField: UITextField!
    @IBOutlet  weak var segmented: UISegmentedControl!
    
    var index: Int = 0
    
    var addName: String = ""
    var addPrice: String = ""
    var addImageUrl: String = ""
    var addUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keywordLabel.text = keyword
        searchedCollectionView.dataSource = self
        searchedCollectionView.delegate = self
        
        searchedCollectionView.layer.cornerRadius = 25
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // vertical scroll
        let size = searchedCollectionView.frame.width
        layout.itemSize = CGSize(width: size / 2 / 1.2, height: size / 2 * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 10,
                                                   left: 20,
                                                   bottom: 30,
                                                   right: 20)
        searchedCollectionView.collectionViewLayout = layout
        
        //長押し時の判定
            // UILongPressGestureRecognizer宣言
            let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                                   action: #selector(ComparePriceViewController.cellLongPressed(_ :)))

            // `UIGestureRecognizerDelegate`を設定するのをお忘れなく
            longPressRecognizer.delegate = self

        // tableViewにrecognizerを設定
        // Add long press gesture recognizer to the collection view cells
        searchedCollectionView.addGestureRecognizer(longPressRecognizer)
        
        segmented.addTarget(self, action: #selector(ValueChanged), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start the API request when the view appears
        startAPI(keyword: keyword)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch index{
        case 0:
             return productUrl.count
        case 1:
            if keyword.lowercased().contains("iphone"){
                return iphonePhysicalUrl.count
            }
            if keyword.lowercased().contains("roland"){
                return rolandPhysicalUrl.count
            }
            return 0
        default:
            print("error")
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 22.5
        let productNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        
        let priceLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        let imageView = cell.contentView.viewWithTag(3) as! UIImageView
        
        let shopNameLabel = cell.contentView.viewWithTag(4) as! UILabel
        
        switch index{
        case 0:
            productNameLabel.text = productNames[indexPath.row]
            priceLabel.text = productPrice[indexPath.row] + "yen"
            let url = URL(string: productImageUrl[indexPath.row])
            shopNameLabel.text = " "
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
        case 1:
            if keyword.lowercased().contains("iphone"){
                shopNameLabel.text = iphonePhysicalShopName[indexPath.row]
                productNameLabel.text = "iPhone 14 128GB"
                priceLabel.text = iphonePhysicalPrice[indexPath.row] + "yen"
                let url = URL(string: iphonePhysicalImageUrl[indexPath.row])
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
            } else if keyword.lowercased().contains("roland"){
                shopNameLabel.text = rolandPhysicalShopName[indexPath.row]
                productNameLabel.text = "Roland FP-30X"
                priceLabel.text = rolandPhysicalPrice[indexPath.row] + "yen" /// sample
                let url = URL(string: rolandPhysicalImageUrl[indexPath.row]) /// sample
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
            }
        default:
            print("error")
        }
        
//        productNameLabel.text = sampleName[indexPath.row] /// sample
//        priceLabel.text = "USD " + samplePrice[indexPath.row] /// sample
//        let url = URL(string: sampleImageUrl[indexPath.row]) /// sample
////        productNameLabel.text = productNames[indexPath.row] /// 本番用
////        priceLabel.text = "USD " + productPrice[indexPath.row] /// 本番用
////        let url = URL(string: productImageUrl[indexPath.row]) /// 本番用
//        DispatchQueue.global().async {
//            do {
//                let imgData = try Data(contentsOf: url!)
//                DispatchQueue.main.async {
//                    imageView.image = UIImage(data: imgData)
//                    cell.setNeedsLayout()
//                }
//            }catch let err {
//                print("Error : (err.localizedDescription)")
//            }
//        }


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                              didSelectItemAt indexPath: IndexPath) {
        
        switch index{
        case 0:
            // move to link of product
            guard let url = URL(string: productUrl[indexPath.row]) else { return }
            UIApplication.shared.open(url)
        case 1:
            // ⚠︎this code is comparison for only iphone and roland
            if keyword.lowercased().contains("iphone"){
                guard let url = URL(string: iphonePhysicalUrl[indexPath.row]) else { return }
                UIApplication.shared.open(url)
            } else if keyword.lowercased().contains("roland"){
                guard let url = URL(string: rolandPhysicalUrl[indexPath.row]) else { return }
                UIApplication.shared.open(url)
            }
//            // move to link of product
//            guard let url = URL(string: sampleUrl[0]) else { return }
//            UIApplication.shared.open(url)
        default:
            print("error")
        }
        // move to link of product
//        guard let url = URL(string: sampleUrl[indexPath.row]) else { return }
//        UIApplication.shared.open(url)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // Start the API request with the given keyword
    @IBAction func startAPI(keyword: String){
        let url = URL(string: base)
        
        print(keyword)
        if keyword != nil{
            print(keyword)
            let headers = [
                "accept": "application/json",
                "content-type": "application/json"
            ]
            let parameters = [
                "source": "amazon",
                "country": "jp",
                "topic": "search_results",
                "key": "term",
                "values": "\(keyword)",
                "max_pages": "10",
                "max_age": "1440",
                "timeout": "5",
                "token": token
            ] as [String : Any]
            
            let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.priceapi.com/v2/jobs?token=\(token)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in guard let data = data else {return}
                do{
                    let requestJSON = try JSONDecoder().decode(initialRequestJSON.self, from: data) //make json parsing easy
                    if requestJSON.status == "new"{
                        print(requestJSON.job_id)
                        self.isJobFinished(requestJSON.job_id)
                    }
                }catch{
                    print("Error getBestPrice")
                }
            })
            
            dataTask.resume()
        }
    }
    
    // Recursive check if the job is finished on the API server
    func isJobFinished(_ id: String) -> Void{
        var isFinished: Bool = false
        let headers = ["accept": "application/json"]
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.priceapi.com/v2/jobs/\(id)?token=\(token)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask =  session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              if let data = data{
                  do{
                      let checkJSON = try JSONDecoder().decode(checkingRequest.self, from: data)
                      print(checkJSON)
                      print(checkJSON.status)
                      if checkJSON.status == "finished" {
                          isFinished = true
                      }
                      if checkJSON.status != "finished"{
                          self.isJobFinished(id)
                      }
                  }catch{
                      print("Error returnJSON")
                      print("after call")
                      print(error)
                  }
              }
          }
            if isFinished {
                self.getResponse(id){
                    DispatchQueue.main.async {
                        self.searchedCollectionView.reloadData()
                        print("done")
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    // Get the API response and update the UI
    func getResponse(_ id: String, completion: @escaping () -> Void){
        sleep(20)///waiting 20 second for waiting creating data completely on the API server.
        let headers = ["accept": "application/json"]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.priceapi.com/v2/jobs/\(id)/download?token=\(token)&job_id=\(id)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              if let data = data{
                  do{
                      let returnJSON = try JSONDecoder().decode(returnJSON.self, from: data)
                      if let searchResults = returnJSON.results?.compactMap({ $0.content?.search_results }) {
                          for searchResult in searchResults {
                            for result in searchResult {
                                print(result.name)
                                self.productNames.append(result.name!)
                                self.productUrl.append(result.url!)
                                self.productPrice.append(result.min_price ?? "0")
                                self.productImageUrl.append(result.image_url!)
                            }
                        }
                      }
                      print(self.productPrice)
                      print(self.productImageUrl)
                      completion()

                  }catch{
                      print("Error returnJSON")
                      print("after call")
                      print(error)
                  }
              }
          }
        })
        dataTask.resume()
    }
    
    // Update Realm database with product information
    func updateRealm(url: String, name: String, imageUrl: String, price: String){
        let productInfo: ProductInfo! = realm.objects(ProductInfo.self).filter("url == %@", addUrl).first
        
        if productInfo != nil {
            try! realm.write {
                productInfo.num += 1
            }
        } else {
            let newProduct = ProductInfo()
            newProduct.name = name
            newProduct.url = url
            newProduct.price = price
            newProduct.imageUrl = imageUrl
            newProduct.num = 1
            try! realm.write {
                realm.add(newProduct)
                print("add done")
            }
        }
    }
    
    @IBAction func ValueChanged(_ sender: UISegmentedControl) {
        index = segmented.selectedSegmentIndex
        self.searchedCollectionView.reloadData()
        print("seg")
    }
}

// MARK: ContextMenuDelegate
extension ComparePriceViewController: ContextMenuDelegate {
    
    func contextMenuDidSelect(_ contextMenu: ContextMenu,
                              cell: ContextMenuCell,
                              targetedView: UIView,
                              didSelect item: ContextMenuItem,
                              forRowAt index: Int) -> Bool {
        
        switch index {
            case 0:
                //0番目のセル(1番上のメニューがタップされると実行されます)
                //この例では編集メニューに設定してあります
                // check which cell tapped
                print(addName)
                updateRealm(url: addUrl, name: addName, imageUrl: addImageUrl, price: addPrice)
            
            default:
                //ここはその他のセルがタップされた際に実行されます
                // called when other cell tapped
                break
            }
            
            return true

    }
    
    func contextMenuDidDeselect(_ contextMenu: ContextMenu,
                                cell: ContextMenuCell,
                                targetedView: UIView,
                                didSelect item: ContextMenuItem,
                                forRowAt index: Int) {
    }
    
    /**
     コンテキストメニューが表示されたら呼ばれる
     */
    func contextMenuDidAppear(_ contextMenu: ContextMenu) {
        print("コンテキストメニューが表示された")
    }
    
//    func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
//        print("コンテキストメニューが消えた")
//    }
    
    /// セルが長押しした際に呼ばれるメソッド
    /// called function when long pressed
    @objc func cellLongPressed(_ recognizer: UILongPressGestureRecognizer) {

        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: searchedCollectionView)
        // 押された位置に対応するindexPath
        let indexPath = searchedCollectionView.indexPathForItem(at: point)
            
        if indexPath == nil {  //indexPathがなかったら
                
            return  //すぐに返り、後の処理はしない
                
        } else if recognizer.state == UIGestureRecognizer.State.began  {
            // 長押しされた場合の処理
            
            switch index{
            case 0:
                // move to link of product
                addName = productNames[indexPath!.row] /// sample用
                addPrice = productPrice[indexPath!.row] /// sample用
                addImageUrl = productImageUrl[indexPath!.row] /// sample用
                addUrl = productUrl[indexPath!.row]
            case 1:
                // move to link of product
//                addName = sampleName[indexPath!.row] /// sample用
//                addPrice = samplePrice[indexPath!.row] /// sample用
//                addImageUrl = sampleImageUrl[indexPath!.row] /// sample用
//                addUrl = sampleUrl[indexPath!.row]
                
                if keyword.lowercased().contains("iphone"){
                    addName = "iPhone 14 128GB" /// sample用
                    addPrice = iphonePhysicalPrice[indexPath!.row] /// sample用
                    addImageUrl = iphonePhysicalImageUrl[indexPath!.row] /// sample用
                    addUrl = iphonePhysicalUrl[indexPath!.row]
                } else if keyword.lowercased().contains("roland"){
                    addName = "Roland FP-30X" /// sample用
                    addPrice = rolandPhysicalPrice[indexPath!.row] /// sample用
                    addImageUrl = rolandPhysicalImageUrl[indexPath!.row] /// sample用
                    addUrl = rolandPhysicalUrl[indexPath!.row]
                }
            default:
                print("error")
            }
            print(indexPath?.row)
//          let addName = productNames[indexPath?.row] /// 本番用
//          let addPrice = "USD " + productPrice[indexPath?.row] /// 本番用
//          let addUrl = URL(string: productImageUrl[indexPath?.row]) /// 本番用
                
            //コンテキストメニューの内容を作成します
            // create content of contextmenu
            let add = ContextMenuItemWithImage(title: "Add to Cart", image: UIImage(systemName: "cart")!)
                
            //コンテキストメニューに表示するアイテムを決定します
            // decide item which is displayed from content of contextmenu
            CM.items = [add]

            CM.showMenu(viewTargeted: searchedCollectionView.cellForItem(at: indexPath!)!,
                        delegate: self,
                        animated: true)
                
        }
    }
    
}
