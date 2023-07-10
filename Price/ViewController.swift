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
//        let freeCredits: Int
//        let paidCredits: Int
        var results: [Result]?
    }

    struct Result: Codable {
//        let query: Query
//        let success: Bool
//        let metadata: Metadata
        var content: Content?
    }
    
    struct Content: Codable{
        var id: String?
        var name: String?
        var image_url: String?
        var description: String?
        var feature_bullets: [String]?
        var properties: [String]?
        var url: String?
        var review_count: Int?
        var review_rating: Int?
        var price: Double?
        var gtins: [String]?
        var eans: [String]?
        var brand_name: String?
        var category_path: String?
        var category_name: String?
        var offer_count: Int?
        var offers_url: String?
        var offers: [Offers]?
    }
    
    struct Offers: Codable {
        var id: String?
        var product_id: String?
        var price: String?
        var price_additional_info: [String]?
        var price_with_shipping: String?
        var shipping_costs: String?
        var tax: String?
        var currency: String?
        var condition_text: String?
        var condition_code: String?
        var url: String?
        var shop_name: String?
        var shop_review_count: Int?
        var shop_review_rating: Int?
        var shop_id: String?
        var shop_sub_id: String?
        var shop_extended_source_id: String?
        var shop_url: String?
       
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("tap")
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
              "values": "\(valueField.text!)",
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
//                    print(requestJSON.job_id)
                    if requestJSON.status == "new"{
                        print(requestJSON.job_id)
//                        self.checkStatus(requestJSON.job_id, baseUrl: self.base)
//                        self.waitResponse(requestJSON.job_id)
//                        self.getResponse(requestJSON.job_id)
//                        self.waitResponse2(requestJSON.job_id)
//                        self.getResponse2(requestJSON.job_id)
//                        print(self.isJobFinished("6492c9ff1a166053f005a126"))
                        self.isJobFinished(requestJSON.job_id)
//                        self.getResponse(requestJSON.job_id)

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
        print("\n\nhttps://api.priceapi.com/v2/jobs/\(id)/download?token=\(token)&job_id=\(id)\n\n")
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
                    print(error)
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
                        print(type(of: checkJSON))
                        print("PriceFinder: \(checkJSON.status)")

                        if(checkJSON.status != "finished"){
                            print(checkJSON.job_id)
                            self.checkStatus(id, baseUrl: baseUrl)
                        } else{
                            self.getJSON(id, baseUrl: self.base)
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
                self.getResponse(id)
            }
        })
        dataTask.resume()
    }
    
    
    func getResponse(_ id:String){
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
                      print(returnJSON)
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

