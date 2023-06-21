//
//  ProductListViewController.swift
//  Price
//
//  Created by Haruto Hamano on 2023/06/20.
//

import UIKit

import Firebase

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet var storeNameLabel: UILabel!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.addObserver(self, forKeyPath: "price", options: [.new], context: nil)
        
        getProducts()

    }
    
    func getProducts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("store").getDocuments() { (querySnapshot, err) in
                
            if let err = err {
                print("Error getting documents: (err)")
                return
            }
            
            for document in querySnapshot!.documents {
                let name = document.data()["name"] as? String
                self.storeNameLabel.text = name
                print(name)
                
            }
        }
     }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")!
//        cell.textLabel?.text = self.categories[indexPath.row]
//        return cell
//    }
        

}
