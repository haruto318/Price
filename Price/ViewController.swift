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
        let results: [Result]
    }

    struct Result: Codable {
//        let query: Query
//        let success: Bool
//        let metadata: Metadata
        let content: Content
    }
    
    struct Content: Codable{
        let id: String
        let name: String
        let image_url: String
        let description: String
        let feature_bullets: [String]
        let properties: [String]
        let url: String
        let review_count: Int
        let review_rating: Int
        let price: Double?
        let gtins: [String]?
        let eans: [String]?
        let brand_name: String?
        let category_path: String?
        let category_name: String?
        let specifications: [String: String]?
        let offer_count: Int
        let offers_url: String
        let offers: [Offers]
    }
    
    struct Offers: Codable {
        let id: String?
        let product_id: String
        let price: String
        let price_additional_info: [String]
        let price_with_shipping: String
        let shipping_costs: String
        let tax: String
        let currency: String
        let condition_text: String?
        let condition_code: String
        let url: String
        let shop_name: String
        let shop_review_count: Int
        let shop_review_rating: Int
        let shop_id: String
        let shop_sub_id: String?
        let shop_extended_source_id: String
        let shop_url: String
       
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
//                        self.checkStatus(requestJSON.job_id, baseUrl: self.base)
//                        self.waitResponse(requestJSON.job_id)
//                        self.getResponse(requestJSON.job_id)
//                        self.waitResponse2(requestJSON.job_id)
//                        self.getResponse2(requestJSON.job_id)
//                        print(self.isJobFinished("6492c9ff1a166053f005a126"))
                        self.getResponse("6492c9ff1a166053f005a126")

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
    
    
    func isJobFinished(_ id: String) -> Bool{
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
                  }catch{
                      print("Error returnJSON")
                      print("after call")
                      print(error)
                  }
              }
          }
        })
        dataTask.resume()
        return isFinished
    }
    
    
    func getResponse(_ id:String){
//        while !isJobFinished(id){
//            print("waiting 20 sencond")
//            sleep(20)
//        }
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

