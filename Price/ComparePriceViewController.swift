//
//  ComparePriceViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit
import SkeletonView

class ComparePriceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let token = "JYYQLVJZXWIGERFAUHEYFUJSCKAMJKFZXJMBJHSQYHGQBZMHGDZDQRZKQTGHXNTU"
    let base = "https://api.priceapi.com/v2/jobs/"
    
    
    struct checkingRequest: Decodable{
        let job_id: String
        let status: String
//        let successful: Int
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
    
    var productNames: [String] = []
    var productUrl: [String] = []
    var productPrice: [String] = []
    var productImageUrl: [String] = []
    
    var keyword: String = ""
    
    @IBOutlet weak var searchedCollectionView: UICollectionView!
    
    @IBOutlet var keywordField: UITextField!
    @IBOutlet var keywordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keywordLabel.text = keyword
        searchedCollectionView.dataSource = self
        searchedCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // vertical scroll
        let size = searchedCollectionView.frame.width
        layout.itemSize = CGSize(width: size / 2 / 1.2, height: size / 2 * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 10,
                                                   left: 20,
                                                   bottom: 30,
                                                   right: 20)
        searchedCollectionView.collectionViewLayout = layout
        
        startAPI()
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productUrl.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 22.5
//        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
//        imageView.image = searchedCollectionView!.elements[indexPath.row].value
        let productNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        productNameLabel.text = productNames[indexPath.row]
        let priceLabel = cell.contentView.viewWithTag(2) as! UILabel
        priceLabel.text = productPrice[indexPath.row]
//        let productImage = cell.contentView.viewWithTag(1) as! UILabel
        return cell
    }
    
    @IBAction func startAPI(){
        let url = URL(string: base)
        
        if keywordField.text != nil{
            let headers = [
              "accept": "application/json",
              "content-type": "application/json"
            ]
            let parameters = [
              "source": "amazon",
              "country": "us",
              "topic": "search_results",
              "key": "term",
              "values": "watch",
//              "values": "\(keywordField.text!)",
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
//                      print(returnJSON)
                      if let searchResults = returnJSON.results?.compactMap({ $0.content?.search_results }) {
                          for searchResult in searchResults {
                            for result in searchResult {
                                print(result.name)
                                self.productNames.append(result.name!)
                                self.productUrl.append(result.url!)
                                self.productPrice.append(result.min_price ?? "0")
                                self.productImageUrl.append(result.image_url!)
//                                print(self.productNames)
//                                print(self.productUrl)
//                                print(self.productPrice)
//                                print(self.productImageUrl)
                            }
                        }
//                          print(self.productInfo[0].url)
                      }
                      print(self.productUrl)
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
}
