//
//  ViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/07.
//

import UIKit

class ViewController: UIViewController {
    let token = "JYYQLVJZXWIGERFAUHEYFUJSCKAMJKFZXJMBJHSQYHGQBZMHGDZDQRZKQTGHXNTU"
    let base = "https://api.priceapi.com/v2/jobs/"
    
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var prices: [String] = [String]()
    
    var finished = false
    var flag = true
    
    struct checkingRequest: Decodable{
        let job_id: String
        let status: String
        let successful: Int
    }
    
    struct initialRequestJSON: Decodable{ //struct for the initial JSON parsing
        let job_id: String
        let status: String
    }
    
    struct returnJSON: Decodable {
        let jobID: String
        let status: String
        let freeCredits: Int
        let paidCredits: Int
        let results: [Result]
    }

    struct Result: Decodable {
//        let query: Query
//        let success: Bool
//        let metadata: Metadata
        let content: Content
    }
    
    struct Content: Decodable{
        let id: String
        let name: String
        let imageUrl: String
        let description: String
        let featureBullets: [String]
        let properties: [String]
        let url: String
        let reviewCount: Int
        let reviewRating: Int
        let price: Double?
        let gtins: [String]?
        let eans: [String]?
        let brandName: String?
        let categoryPath: String?
        let categoryName: String?
        let specifications: [String: String]?
        let offerCount: Int
        let offersURL: String
        let offers: [Offers]
    }
    
    struct Offers: Decodable {
        let id: String?
        let productID: String
        let price: String
        let priceAdditionalInfo: [String]
        let priceWithShipping: String
        let shippingCosts: String
        let tax: String
        let currency: String
        let conditionText: String?
        let conditionCode: String
        let url: String
        let shopName: String
        let shopReviewCount: Int
        let shopReviewRating: Int
        let shopID: String
        let shopSubID: String?
        let shopExtendedSourceID: String
        let shopURL: String
       
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("tap")
        getJSON("649068edbacddc474c201521", baseUrl: base)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapButton(){
        print("tapped")
                
        let url = URL(string: base)
        
        if valueField.text != nil{
            let headers = [
              "accept": "application/json",
              "content-type": "application/json"
            ]
            let parameters = [
              "source": "google_shopping",
              "country": "us",
              "topic": "product_and_offers",
              "key": "term",
              "values": "\(valueField.text)",
              "max_pages": "3",
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
//                    print(requestJSON.job_id)
                    if requestJSON.status == "new"{
                        print(requestJSON.job_id)
                        self.checkStatus(requestJSON.job_id, baseUrl: self.base)

                    }
//                        self.checkStatus(requestJSON.job_id, baseUrl: base, itemName: self.valueField.text!)
                }catch{
                    print("Error getBestPrice")
                }
            })

            dataTask.resume()
        }
    }
    
    func getJSON(_ id: String, baseUrl: String){
        let headers = ["accept": "application/json"]
//        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)See%20step%201/download?token=\(token)&job_id=\(id)")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.priceapi.com/v2/jobs/\(id)/download?token=\(token)&job_id=\(id)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let data = data{
                do{
                    let returnJSON = try JSONDecoder().decode(returnJSON.self, from: data)
                    print(returnJSON)

                }catch{
                    print("Error returnJSON")
                    print("after call")
                }
            }
            
//            if (error != nil) {
//                print(error as Any)
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                print(httpResponse)
//            }
        })
        dataTask.resume()
    }
    
    func checkStatus(_ id: String, baseUrl: String){
        let token = "?token=\(token)"
        let statusURL = URL(string: baseUrl + id + token)
        let statusSession = URLSession.shared
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let statusTask = statusSession.dataTask(with: statusURL!) { (data, response, error) in
                if let data = data{
                    do{
                        let checkJSON = try JSONDecoder().decode(checkingRequest.self, from: data)
                        print("PriceFinder: \(checkJSON.status)")

                        if(checkJSON.status != "finished"){
                            print(checkJSON.job_id)
                            self.checkStatus(id, baseUrl: baseUrl)
                        } else{
                            self.getJSON(id, baseUrl: baseUrl)
                        }

                    }catch{
                        print("Error checkStatus")
//                        self.checkStatus(id, baseUrl: baseUrl)
                        print("after call")
                    }
                }
            }
            statusTask.resume()
        }
    }

}

